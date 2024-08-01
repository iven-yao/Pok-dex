const express = require('express');
const PokemonImage = require('../models/PokemonImage');

const router = express.Router();

// @route   GET api/pokemon_images/
// @desc    get all images data
// @access  Public
router.get('/', async (req, res) => {
    try {
        const pokemon_images = await PokemonImage.getAll();

        res.json(pokemon_images);

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

module.exports = router;