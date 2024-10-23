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

async function createPlant(event) {
    if (!event.body) return { statusCode: 400, body: "Must specify a request body" };

    const token = event.headers.authorization;
    const decoded = jwt.jwtDecode(token);

    let body = JSON.parse(event.body);
    if (!body.name) return { statusCode: 400, body: "Must specify a name in the request body" };
    if (!body.waterFrequencyDays) return { statusCode: 400, body: "Must specify a waterFrequencyDays in the request body" };

    const plantId = await pg.insert("plants", {
        name: body.name,
        description: body.description,
        water_frequency_days: body.waterFrequencyDays,
        uuid: decoded.username
    });

    return {
        statusCode: 200,
        body: JSON.stringify({ plantId: plantId }),
    };
}

module.exports = {
    createPlant: createPlant,
}
