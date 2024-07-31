const express = require('express');
const axios = require('axios');
const Pokemon = require('../models/Pokemon');
const { decodedStats, getAbilityIdFromUrl } = require('../utils/pokemonDataUtils');
const PokemonAbility = require('../models/Pokemon_Ability');
const { POKEAPI_BASE_URL } = require('../utils/constants');

const router = express.Router();

// @route   GET api/pokemon/
// @desc    get all pokemon data
// @access  Public
router.get('/', async (req, res) => {
    try {
        const pokemons = await Pokemon.getAll();

        res.json({pokemons});

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

// @route   POST api/pokemon/seedFromPokeAPI
// @desc    insert pokemon records based on PokeAPI
// @access  Should be private, not yet implement
router.post('/seedFromPokeAPI', async (req, res) => {  
    try {
        const response = await axios.get(`${POKEAPI_BASE_URL}/pokemon?limit=${process.env.POKEMON_LIMIT || 1025}`);
        const pokemons = response.data.results;

        for(const pokemon of pokemons) {
            const detailResponse = await axios.get(pokemon.url);
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

            await Pokemon.create(pokemonData);

            for(const ability of detailResponse.data.abilities) {
                const relationData = {
                    pokemon_id: detailResponse.data.id, 
                    ability_id: getAbilityIdFromUrl(ability.ability.url),
                    is_hidden: ability.is_hidden
                }

                await PokemonAbility.create(relationData);
            }
        }
        
        res.json({msg: `successfully insert pokemons data`});
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

module.exports = router;