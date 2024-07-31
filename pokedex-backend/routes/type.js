const express = require('express');
const axios = require('axios');
const Type = require('../models/Types');
const { POKEAPI_BASE_URL } = require('../utils/constants');

const router = express.Router();

// @route   GET api/type/
// @desc    get all type data
// @access  Public
router.get('/', async (req, res) => {
    try {
        const types = await Type.getAll();

        res.json({types});

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

// @route   POST api/type/seedFromPokeAPI
// @desc    insert type records based on PokeAPI
// @access  Should be private, not yet implement
router.post('/seedFromPokeAPI', async (req, res) => {  
    try {
        const response = await axios.get(`${POKEAPI_BASE_URL}/type?limit=${process.env.TYPE_LIMIT || 18}`);
        const types = response.data.results;

        for(const type of types) {
            const detailResponse = await axios.get(type.url);
            const typeData = {
                id: detailResponse.data.id,
                name: detailResponse.data.name,
            };

            await Type.create(typeData);

        }
        
        res.json({msg: `successfully insert types data`});
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

module.exports = router;