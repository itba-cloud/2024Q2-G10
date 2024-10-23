const PgConnection = require("postgresql-easy");
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { PutCommand, DynamoDBDocumentClient } = require("@aws-sdk/lib-dynamodb");
const jwt = require('jwt-decode');

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

async function createPlantWatering(event) {
    const token = event.headers.authorization;
    const decoded = jwt.jwtDecode(token);

    let plantId = Number(event.pathParameters.plantId);

    let row = await pg.query("SELECT * FROM plants WHERE id = $1", plantId);
    if (row.length == 0) {
        return { statusCode: 404, body: "Not Found" };
    }

    row = row[0];
    let uuid = row["uuid"]

    if (uuid !== decoded.username) {
        return { statusCode: 401, body: "Unauthorized" };
    }

    let timestamp = new Date().toISOString();

    let body = event?.body;
    body = body ? JSON.parse(body) : body;
    let description = body?.description;

    const command = new PutCommand({
        TableName: "waterings",
        Item: { plantId: plantId, timestamp: timestamp, description: description }
    });

    const dynamoResponse = await dynamo.send(command);

    return {
        statusCode: 200
    };
}

module.exports = {
    createPlantWatering: createPlantWatering,
}
