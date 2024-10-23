const PgConnection = require("postgresql-easy");
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { QueryCommand, DynamoDBDocumentClient } = require("@aws-sdk/lib-dynamodb");
const jwt = require('jwt-decode');

const pg = new PgConnection({
    host: process.env.DB_HOST,
    port: 5432,
    database: "postgres",
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    ssl: true,
});

// https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/javascript_dynamodb_code_examples.html
const dynamoClient = new DynamoDBClient({});
const dynamo = DynamoDBDocumentClient.from(dynamoClient);

async function getPlants(event) {
    let page = Math.max(0, event?.queryStringParameters?.page ?? 0);
    let pageSize = Math.min(Math.max(0, event?.queryStringParameters?.pageSize ?? 10), 100);

    const token = event.headers.authorization;
    const decoded = jwt.jwtDecode(token);

    let plantRows = await pg.query("SELECT * FROM plants where uuid = $1 ORDER BY id DESC LIMIT $2 OFFSET $3", decoded.username, pageSize, page * pageSize);

    let plants = [];
    for (let i = 0; i < plantRows.length; i++) {
        let row = plantRows[i];
        let plantId = row["id"];
        let name = row["name"];
        let description = row["description"];
        let waterFrequencyDays = row["water_frequency_days"];
        let image = row["image"];

        const command = new QueryCommand({
            TableName: "waterings",
            KeyConditionExpression: "plantId = :plantId",
            ExpressionAttributeValues: { ":plantId": plantId },
            ConsistentRead: true,
        });

        let waterings = [];
        const dynamoResponse = await dynamo.send(command);
        dynamoResponse.Items.forEach(ele => waterings.push(ele.timestamp));

        plants.push({
            plantId: plantId,
            name: name,
            description: description,
            waterFrequencyDays: waterFrequencyDays,
            image: image,
            waterings: waterings,
        });
    }

    return {
        statusCode: 200,
        body: JSON.stringify(plants),
    };
}

module.exports = {
    getPlants: getPlants,
}
