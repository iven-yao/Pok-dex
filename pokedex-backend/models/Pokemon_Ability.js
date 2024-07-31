const {pool} = require('../config/db');

class PokemonAbility {
    static async getAll() {
        const result = await pool.query('SELECT * FROM pokemon_ability ORDER BY id');
        return result.rows;
    }

    static async create(relationData) {
        const {pokemon_id, ability_id, is_hidden} = relationData;
        await pool.query(
            '\
            INSERT INTO pokemon_ability (pokemon_id, ability_id, is_hidden) \
            VALUES ($1, $2, $3) \
            ON CONFLICT (pokemon_id, ability_id) DO NOTHING',
            [pokemon_id, ability_id, is_hidden]
        );
    }

    static async createInBatch(client, relationData) {
        const relationInsertStmt = '\
        INSERT INTO pokemon_ability (pokemon_id, ability_id, is_hidden) \
        SELECT * FROM UNNEST ($1::int[], $2::int[], $3::boolean[]) ON CONFLICT (pokemon_id, ability_id) DO NOTHING';

        await client.query(relationInsertStmt, [
            relationData.map(r => r.pokemon_id),
            relationData.map(r => r.ability_id),
            relationData.map(r => r.is_hidden)
        ]);
    }

}

module.exports = PokemonAbility;