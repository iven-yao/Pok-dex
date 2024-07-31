const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const {authenticateToken} = require('../middleware/auth');
const { generateAccessToken, generateRefreshToken } = require('../utils/tokenUtils');

const router = express.Router();

// @route   POST api/auth/register
// @desc    Register a user
// @access  Public
router.post('/register', async (req, res) => {
    const { username, email, password } = req.body;

    try {
        // check if user already exists
        const existingUser = await User.findByEmail(email);
        if (existingUser) {
            return res.status(400).json({ error: 'User with this email already exists' });
        }

        // Create new user
        const newUser = await User.create(username, email, password);

        const accessToken = generateAccessToken(newUser.id);
        const refreshToken = generateRefreshToken(newUser.id);

        await User.renewRefreshToken(newUser.id, refreshToken);

        res.json({ accessToken, refreshToken });

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

// @route   POST api/auth/login
// @desc    Authenticate user & get token
// @access  Public
router.post('/login', async (req, res) => {
    const { email, password } = req.body;
  
    try {
        const user = await User.findByEmail(email);
        if (!user) {
            return res.status(401).json({ msg: 'Invalid credentials' });
        }
    
        const validPassword = await bcrypt.compare(password, user.password);
        if (!validPassword) {
            return res.status(401).json({ msg: 'Invalid credentials' });
        }
    
        const accessToken = generateAccessToken(user.id);
        const refreshToken = generateRefreshToken(user.id);
    
        await User.renewRefreshToken(user.id, refreshToken);
    
        res.json({ accessToken, refreshToken });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

// @route   POST api/auth/refresh-token
// @desc    Get new access token with refresh token
// @access  Public
router.post('/refresh-token', async (req, res) => {
    const { refreshToken } = req.body;
  
    if (!refreshToken) {
        return res.status(401).json({ msg: 'No refresh token provided' });
    }
  
    try {
        const decoded = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
        const user = await User.findById(decoded.user.id);

        if (!user || user.refresh_token !== refreshToken) {
            return res.status(401).json({ msg: 'Invalid refresh token' });
        }
    
        const accessToken = generateAccessToken(user.id);
        res.json({ accessToken });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

// @route   POST api/auth/logout
// @desc    Log user out, and remove refresh token
// @access  Private
router.put('/logout', authenticateToken, async (req, res) => {
    try {        
        await User.removeRefreshToken(req.user.id);
        
        res.json({ msg: 'Logged out successfully' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

// @route   GET api/auth/user
// @desc    Get logged in user
// @access  Private
router.get('/user', authenticateToken, async (req, res) => {
    try {
        const name = await User.getUserName(req.user.id);
        res.json(name);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

module.exports = router;