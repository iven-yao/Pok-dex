const {pool} = require('../config/db');

class Type {
    static async getAll() {
        const result = await pool.query('SELECT * FROM types ORDER BY id');
        return result.rows;
    }

    static async create(typeData) {
        const {id, name} = typeData;
        await pool.query(
            '\
            INSERT INTO types (id, name) \
            VALUES ($1, $2) \
            ON CONFLICT (id) DO NOTHING',
            [id, name]
        );
    }

    static async createInBatch(client, typeData) {
        const typeInsertQuery = `
            INSERT INTO types (id, name)
            SELECT * FROM UNNEST ($1::int[], $2::text[])
            ON CONFLICT (id) DO NOTHING
        `;

        await client.query(typeInsertQuery, [
            typeData.map(t => t.id),
            typeData.map(t => t.name)
        ]);
    }
}

module.exports = Type;