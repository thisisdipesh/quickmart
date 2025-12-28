const express = require('express');
const router = express.Router();
const {
  getAllUsers,
  getMe,
  updateMe,
} = require('../controllers/userController');
const { protect, authorize } = require('../middleware/authMiddleware');
const { validate } = require('../middleware/validation');

// @route   GET /api/users
router.get('/', protect, authorize('admin'), getAllUsers);

// @route   GET /api/users/me
router.get('/me', protect, getMe);

// @route   PUT /api/users/me
router.put('/me', protect, validate('updateUser'), updateMe);

module.exports = router;






