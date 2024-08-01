const { POKEAPI_BASE_URL } = require("../utils/constants");
const { getAbilityIdFromUrl, decodedStats } = require("../utils/pokemonDataUtils");
const { fetchWithRetry, fetchDetails } = require("../utils/axiosUtils");
const Pokemon = require("../models/Pokemon");
const PokemonAbility = require("../models/Pokemon_Ability");
const PokemonImage = require("../models/PokemonImage");

const seedPokemon = async (client, multibar) => {

    try {
        const response = await fetchWithRetry(`${POKEAPI_BASE_URL}/pokemon?limit=${process.env.POKEMON_LIMIT || 151}`);
        const pokemons = response.data.results;
        const bar = multibar.create(pokemons.length, 0, {filename: "seedPokemon"});

        const batchSize = 50;
        for(let i = 0; i < pokemons.length; i += batchSize) {
            const batch = pokemons.slice(i, i+batchSize);

            const pokemonDetails = await Promise.all(batch.map(pokemon => fetchDetails(pokemon.url)));
            const pokemonDataList = pokemonDetails.map(detail => ({
                id: detail.id,
                name: detail.name,
                type_1: detail.types[0].type.name,
                type_2: detail.types[1]?.type.name || null,
                height: detail.height,
                weight: detail.weight,
                image_url: detail.sprites.front_default,
                ...decodedStats(detail.stats)
            }));

            await Pokemon.createInBatch(client, pokemonDataList);

            const relationData = pokemonDetails.flatMap(detail =>
                detail.abilities.map(ability => ({
                    pokemon_id: detail.id,
                    ability_id: getAbilityIdFromUrl(ability.ability.url),
                    is_hidden: ability.is_hidden
                }))
            );

            await PokemonAbility.createInBatch(client, relationData);

            const imagesData = pokemonDetails.flatMap(detail =>{
                const entries = Object.entries(detail.sprites);
                return entries.filter(([key, value]) => key !== 'versions' && value !== null)
                .flatMap(([key, value]) => {
                    
                    if(key === 'other') {
                        const officialArtworkEntries = Object.entries(value["official-artwork"]);
                        return officialArtworkEntries.map(([official_key, official_value]) =>({
                            pokemon_id: detail.id,
                            description: `official_artwork_${official_key}`,
                            image_url: official_value
                        }));
                    }

                    return ({
                        pokemon_id: detail.id,
                        description: key,
                        image_url: value
                    })
                })
            });
            
            await PokemonImage.createInBatch(client, imagesData);

            bar.increment(batch.length);
        }
        
    } catch (err) {
        console.error(err.message);
        throw err;
    }
}

module.exports = {seedPokemon}