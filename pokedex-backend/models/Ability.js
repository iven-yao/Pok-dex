const {pool} = require('../config/db');

class Ability {
    static async getAll() {
        const result = await pool.query('SELECT * FROM abilities ORDER BY id');
        return result.rows;
    }

    static async create(abilityData) {
        const {id, name, description} = abilityData;
        await pool.query(
            '\
            INSERT INTO abilities (id, name, description) \
            VALUES ($1, $2, $3) \
            ON CONFLICT (id) DO NOTHING',
            [id, name, description]
        );

    }

    static async createInBatch(client, abilityData) {
        const abilityInsertQuery = `
        INSERT INTO abilities (id, name, description)
        SELECT * FROM UNNEST ($1::int[], $2::text[], $3::text[])
        ON CONFLICT (id) DO NOTHING
        `;

        await client.query(abilityInsertQuery, [
            abilityData.map(a => a.id),
            abilityData.map(a => a.name),
            abilityData.map(a => a.description)
        ]);
    }

}

module.exports = Ability;