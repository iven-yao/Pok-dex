const express = require('express');
const Type = require('../models/Types');

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

module.exports = router;