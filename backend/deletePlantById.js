const PgConnection = require("postgresql-easy");
const jwt = require('jwt-decode');

const pg = new PgConnection({
    host: process.env.DB_HOST,
    port: 5432,
    database: "postgres",
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    ssl: true,
});

async function deletePlantById(event) {
    const token = event.headers?.authorization;
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

    let result = pg.deleteById("plants", plantId);

    return {
        statusCode: 200,
        body: JSON.stringify(result)
    };
}

module.exports = {
    deletePlantById: deletePlantById,
}
