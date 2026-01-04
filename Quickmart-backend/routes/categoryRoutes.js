const express = require('express');
const router = express.Router();
const {
  createCategory,
  getAllCategories,
  getCategoryById,
  updateCategory,
  deleteCategory,
} = require('../controllers/categoryController');
const { protect, authorize } = require('../middleware/authMiddleware');
const { validate } = require('../middleware/validation');
const { uploadCategoryIcon } = require('../middleware/upload');

// @route   GET /api/categories
router.get('/', getAllCategories);

// @route   GET /api/categories/:id
router.get('/:id', getCategoryById);

// @route   POST /api/categories
router.post(
  '/',
  protect,
  authorize('admin'),
  uploadCategoryIcon.single('icon'),
  validate('createCategory'),
  createCategory
);

// @route   PUT /api/categories/:id
router.put(
  '/:id',
  protect,
  authorize('admin'),
  uploadCategoryIcon.single('icon'),
  validate('updateCategory'),
  updateCategory
);

// @route   DELETE /api/categories/:id
router.delete('/:id', protect, authorize('admin'), deleteCategory);

module.exports = router;








