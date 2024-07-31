const express = require('express');
const axios = require('axios');
const PokemonAbility = require('../models/Pokemon_Ability');

const router = express.Router();

// @route   GET api/pokemon_ability/
// @desc    get all ability data
// @access  Public
router.get('/', async (req, res) => {
    try {
        const relations = await PokemonAbility.getAll();

        res.json({relations});

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

module.exports = router;