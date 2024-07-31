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

}

module.exports = Type;