import express from "express" ;
const router = express.Router();

// Define your routes here
router.get('/', (req, res) => {
    // Handle GET request for users
    res.send('Get all users');
  });

// Export the router
export default router;