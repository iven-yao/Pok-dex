const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
    // get token from headers
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token == null) return res.status(401).json({ msg: 'Token not found' });

    // Verify token
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded.user;
        next();
    } catch (err) {
        res.status(403).json({ msg: 'Token is not valid' });
    }
};

module.exports = {authenticateToken};