const PgConnection = require("postgresql-easy");
const fs = require('fs');
const path = require('path');

exports.handler = async (event) => {
    const client = new PgConnection({
        user: process.env.DB_USER,
        host: process.env.DB_HOST,
        database: process.env.DB_NAME,
        password: process.env.DB_PASSWORD,
        port: process.env.DB_PORT,
        ssl: true
    });

    try {
        const sqlFilePath = path.join(__dirname, 'schema.sql');
        const sql = fs.readFileSync(sqlFilePath, 'utf8');

        await client.query(sql);
        return {
            statusCode: 200,
            body: JSON.stringify('Tables created successfully!'),
        };
    } catch (err) {
        console.error('Error creating tables:', err);
        return {
            statusCode: 500,
            body: JSON.stringify('Error creating tables' + err),
        };
    } finally {
        await client.disconnect();
    }
};
