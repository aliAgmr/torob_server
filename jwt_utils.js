const jwt = require('jsonwebtoken');

const JWT_KEY = "f3Z1LAFUp1P5YuS4VZDySIiIY7hSkAykqhWxHth6nvhImd7kIpfEWZbl7nxr";
const JWT_EXPIRY_SECOND = 300

function parseJwt(token) {
    try {
        return jwt.verify(token, JWT_KEY);
    } catch (err) {
        return null;
    }
}

function generateJwt(payload) {
    return jwt.sign(payload, JWT_KEY, {
        expiresIn: JWT_EXPIRY_SECOND
    });
}

module.exports = {
    parseJwt, generateJwt
}