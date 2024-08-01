const express = require('express');
const Ability = require('../models/Ability');
const router = express.Router();

// @route   GET api/ability/
// @desc    get all ability data
// @access  Public
router.get('/', async (req, res) => {
    try {
        const abilities = await Ability.getAll();

        res.json(abilities);

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

module.exports = router;