const PgConnection = require("postgresql-easy");
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { QueryCommand, DynamoDBDocumentClient } = require("@aws-sdk/lib-dynamodb");

const pg = new PgConnection({
    host: process.env.DB_HOST,
    port: 5432,
    database: "postgres",
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    ssl: true,
});

const dynamoClient = new DynamoDBClient({});
const dynamo = DynamoDBDocumentClient.from(dynamoClient);

async function getPlantById(event) {
    let plantId = Number(event.pathParameters.plantId);
    let row = await pg.query("SELECT * FROM plants WHERE id = $1", plantId);
    if (row.length == 0) {
        return { statusCode: 404, body: "Not Found" };
    }

    row = row[0];
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

    let plant = {
        plantId: plantId,
        name: name,
        description: description,
        waterFrequencyDays: waterFrequencyDays,
        image: image,
        waterings: waterings,
    };

    return {
        statusCode: 200,
        body: JSON.stringify(plant),
    };
}

module.exports = {
    getPlantById: getPlantById,
}
