const express = require("express");
const { login, authenticateToken } = require('../controllers/login');


const api = express.Router();

api.post("/login", login);

api.get("/protected", authenticateToken, (req, res) => {
    res.status(200).json({
        message: "You are authorized to see this message.",
    });
});

// Error handling for invalid tokens
api.use((err, req, res, next) => {
    if (err.name === 'UnauthorizedError') {
      // Handle unauthorized access
      res.status(401).json({ error: 'Invalid token' });
    } else {
      // Handle other errors
      console.error('Unhandled error:', err);
      res.status(500).json({ error: 'Internal server error' });
    }
  });

module.exports = api;
