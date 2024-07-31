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

}

module.exports = Ability;