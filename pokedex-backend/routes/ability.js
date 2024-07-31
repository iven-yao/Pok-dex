const express = require('express');
const axios = require('axios');
const { getAbilityDescription } = require('../utils/pokemonDataUtils');
const Ability = require('../models/Ability');
const { POKEAPI_BASE_URI } = require('../utils/constants');

const router = express.Router();

// @route   GET api/ability/
// @desc    get all ability data
// @access  Public
router.get('/', async (req, res) => {
    try {
        const abilities = await Ability.getAll();

        res.json({abilities});

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

// @route   POST api/ability/seedFromPokeAPI
// @desc    insert ability records based on PokeAPI
// @access  Should be private, not yet implement
router.post('/seedFromPokeAPI', async (req, res) => {  
    try {
        const response = await axios.get(`${POKEAPI_BASE_URI}/ability?limit=${process.env.ABILITY_LIMIT || 1000}`);
        const abilities = response.data.results;

        for(const ability of abilities) {
            const detailResponse = await axios.get(ability.url);
            const abilityData = {
                id: detailResponse.data.id,
                name: detailResponse.data.name,
                description: getAbilityDescription(detailResponse.data.flavor_text_entries)
            };

            await Ability.create(abilityData);

        }
        
        res.json({msg: `successfully insert abilities data`});
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

module.exports = router;