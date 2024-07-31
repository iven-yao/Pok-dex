const { POKEAPI_BASE_URI } = require("../utils/constants");
const { getAbilityIdFromUrl, decodedStats } = require("../utils/pokemonDataUtils");
const { fetchWithRetry } = require("../utils/axiosUtils");

const seedPokemon = async (client, multibar) => {
    try {
        const response = await fetchWithRetry(`${POKEAPI_BASE_URI}/pokemon?limit=${process.env.POKEMON_LIMIT || 151}`);
        const pokemons = response.data.results;
        const bar = multibar.create(pokemons.length, 0, {filename: "seedPokemon"});

        for(const pokemon of pokemons) {
            const detailResponse = await fetchWithRetry(pokemon.url);
            const pokemonData = {
                id: detailResponse.data.id,
                name: detailResponse.data.name,
                type_1: detailResponse.data.types[0].type.name,
                type_2: detailResponse.data.types[1]?.type.name || null,
                height: detailResponse.data.height,
                weight: detailResponse.data.weight,
                image_url: detailResponse.data.sprites.front_default,
                ...decodedStats(detailResponse.data.stats)
            };

            const {id, name, type_1, type_2, height, weight, hp, attack, defense, special_attack, special_defense, speed, image_url} = pokemonData;
            await client.query(
                '\
                INSERT INTO pokemons (id, name, type_1, type_2, height, weight, hp, attack, defense, special_attack, special_defense, speed, image_url) \
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) \
                ON CONFLICT (id) DO NOTHING',
                [id, name, type_1, type_2, height, weight, hp, attack, defense, special_attack, special_defense, speed, image_url]
            );

            for(const ability of detailResponse.data.abilities) {
                const relationData = {
                    pokemon_id: detailResponse.data.id, 
                    ability_id: getAbilityIdFromUrl(ability.ability.url),
                    is_hidden: ability.is_hidden
                }

                const {pokemon_id, ability_id, is_hidden} = relationData;
                await client.query(
                    '\
                    INSERT INTO pokemon_ability (pokemon_id, ability_id, is_hidden) \
                    VALUES ($1, $2, $3) \
                    ON CONFLICT (pokemon_id, ability_id) DO NOTHING',
                    [pokemon_id, ability_id, is_hidden]
                );
            }

            bar.increment();
        }
        
    } catch (err) {
        console.error(err.message);
        throw err;
    }
}

module.exports = {seedPokemon}