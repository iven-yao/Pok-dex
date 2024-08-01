const express = require('express');
const Pokemon = require('../models/Pokemon');

const router = express.Router();

// @route   GET api/pokemon/
// @desc    get all pokemon data
// @access  Public
router.get('/', async (req, res) => {
    try {
        const pokemons = await Pokemon.getAll();

        res.json(pokemons);

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});


module.exports = router;