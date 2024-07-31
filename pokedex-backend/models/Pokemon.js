const {pool} = require('../config/db');

class Pokemon {
    static async getAll() {
        const result = await pool.query('SELECT * FROM pokemons ORDER BY id');
        return result.rows;
    }

    static async create(pokemonData) {
        const {id, name, type_1, type_2, height, weight, hp, attack, defense, special_attack, special_defense, speed, image_url} = pokemonData;
        const result = await pool.query(
            '\
            INSERT INTO pokemons (id, name, type_1, type_2, height, weight, hp, attack, defense, special_attack, special_defense, speed, image_url) \
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) \
            ON CONFLICT (id) DO NOTHING',
            [id, name, type_1, type_2, height, weight, hp, attack, defense, special_attack, special_defense, speed, image_url]
        );
    }

    static async createInBatch(client, pokemonDataList) {
        const pokemonInsertStmt = '\
        INSERT INTO pokemons (id, name, type_1, type_2, height, weight, hp, attack, defense, special_attack, special_defense, speed, image_url) \
        SELECT * FROM UNNEST ($1::int[], $2::text[], $3::text[], $4::text[], $5::int[], $6::int[], \
        $7::int[], $8::int[], $9::int[], $10::int[], $11::int[], $12::int[], $13::text[]) ON CONFLICT (id) DO NOTHING';

        await client.query(pokemonInsertStmt, [
            pokemonDataList.map(p => p.id),
            pokemonDataList.map(p => p.name),
            pokemonDataList.map(p => p.type_1),
            pokemonDataList.map(p => p.type_2),
            pokemonDataList.map(p => p.height),
            pokemonDataList.map(p => p.weight),
            pokemonDataList.map(p => p.hp),
            pokemonDataList.map(p => p.attack),
            pokemonDataList.map(p => p.defense),
            pokemonDataList.map(p => p.special_attack),
            pokemonDataList.map(p => p.special_defense),
            pokemonDataList.map(p => p.speed),
            pokemonDataList.map(p => p.image_url)
        ]);

    }

}

module.exports = Pokemon;