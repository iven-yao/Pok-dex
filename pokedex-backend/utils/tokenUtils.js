const jwt = require('jsonwebtoken');

const generateAccessToken = (userId) => {
  return jwt.sign({ user: { id: userId } }, process.env.JWT_SECRET, { expiresIn: '1d' });
};

const generateRefreshToken = (userId) => {
  return jwt.sign({ user: { id: userId } }, process.env.REFRESH_TOKEN_SECRET, { expiresIn: '7d' });
};

module.exports = { generateAccessToken, generateRefreshToken };