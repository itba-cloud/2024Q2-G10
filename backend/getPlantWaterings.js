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

async function getPlantWaterings(event) {
    let plantId = Number(event.pathParameters.plantId);

    const command = new QueryCommand({
        TableName: "waterings",
        KeyConditionExpression: "plantId = :plantId",
        ExpressionAttributeValues: { ":plantId": plantId },
        ConsistentRead: true,
    });

    let waterings = [];
    const dynamoResponse = await dynamo.send(command);
    dynamoResponse.Items.forEach(ele => waterings.push(ele.timestamp));

    return {
        statusCode: 200,
        body: JSON.stringify(waterings),
    };
}

module.exports = {
    getPlantWaterings: getPlantWaterings,
}
