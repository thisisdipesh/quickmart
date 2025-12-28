const express = require('express');
const router = express.Router();
const {
  createProduct,
  getAllProducts,
  getProductById,
  getProductsByCategory,
  updateProduct,
  deleteProduct,
} = require('../controllers/productController');
const { protect, authorize } = require('../middleware/authMiddleware');
const { validate } = require('../middleware/validation');
const { uploadProductImage } = require('../middleware/upload');

// @route   GET /api/products
router.get('/', getAllProducts);

// @route   GET /api/products/category/:categoryId
router.get('/category/:categoryId', getProductsByCategory);

// @route   GET /api/products/:id
router.get('/:id', getProductById);

// @route   POST /api/products
router.post(
  '/',
  protect,
  authorize('admin'),
  uploadProductImage.single('image'),
  createProduct
);

// @route   PUT /api/products/:id
router.put(
  '/:id',
  protect,
  authorize('admin'),
  uploadProductImage.single('image'),
  updateProduct
);

// @route   DELETE /api/products/:id
router.delete('/:id', protect, authorize('admin'), deleteProduct);

module.exports = router;






