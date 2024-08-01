const {pool} = require('../config/db');

class PokemonImage {
    static async getAll() {
        const result = await pool.query('SELECT * FROM pokemon_images ORDER BY id');
        return result.rows;
    }

    static async create(typeData) {
        const {id, name} = typeData;
        await pool.query(
            '\
            INSERT INTO pokemon_images (id, pokemon_id, description, image_url) \
            VALUES ($1, $2) \
            ON CONFLICT (id) DO NOTHING',
            [id, name]
        );
    }

    static async createInBatch(client, imageData) {
        const pokemonImageInsertQuery = '\
            INSERT INTO pokemon_images (pokemon_id, description, image_url) \
            SELECT * FROM UNNEST ($1::int[], $2::text[], $3::text[]) \
            ON CONFLICT (pokemon_id, description) DO UPDATE SET \
            image_url = EXCLUDED.image_url \
        ';

        await client.query(pokemonImageInsertQuery, [
            imageData.map(t => t.pokemon_id),
            imageData.map(t => t.description),
            imageData.map(t => t.image_url),
        ]);
    }
}

module.exports = PokemonImage;