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

}

module.exports = Pokemon;