const jwt = require('jsonwebtoken');
const expressJwt = require('express-jwt');
const { db } = require("../config/database.js");
const { collection, query, where, getDocs} = require("firebase/firestore");

const secretKey = 'your_secret_key'; // Replace with a secure secret key

const generateToken = (user) => {
  return jwt.sign({ user }, secretKey, { expiresIn: '1h' });
};

const authenticateToken = expressJwt({ secret: secretKey, algorithms: ['HS256'] });

const login = async (req, res) => {

    const user = { username, password } = req.body;

    const accountQuery = query(collection(db, 'accounts'), where("username", "==", username));
    const accountSnapshot = await getDocs(accountQuery);

    if (accountSnapshot.empty) {
        res.status(401).json({
            error: "Invalid credentials",
        });
        return;
    }

    const account = accountSnapshot.docs[0].data();

    if (account.password !== password) {
        res.status(401).json({
            error: "Invalid credentials",
        });
        return;
    }

    const token = generateToken(user);

    res.status(200).json({
        token: token,
    });
}

module.exports = {
  generateToken,
  authenticateToken,
  login
};