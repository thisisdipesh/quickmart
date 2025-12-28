const express = require('express');
const router = express.Router();
const {
  createOrder,
  getAllOrders,
  getOrderById,
  getMyOrders,
  updateOrderStatus,
  updateOrderStatusOnly,
  deleteOrder,
} = require('../controllers/orderController');
const { protect, authorize } = require('../middleware/authMiddleware');
const { validate } = require('../middleware/validation');

// @route   POST /api/orders
router.post('/', protect, validate('createOrder'), createOrder);

// @route   GET /api/orders/user/my-orders
router.get('/user/my-orders', protect, getMyOrders);

// @route   GET /api/orders
router.get('/', protect, authorize('admin'), getAllOrders);

// @route   GET /api/orders/:id
router.get('/:id', protect, getOrderById);

// @route   PUT /api/orders/:id/status
router.put(
  '/:id/status',
  protect,
  authorize('admin'),
  updateOrderStatusOnly
);

// @route   PUT /api/orders/:id
router.put(
  '/:id',
  protect,
  authorize('admin'),
  validate('updateOrder'),
  updateOrderStatus
);

// @route   DELETE /api/orders/:id
router.delete('/:id', protect, authorize('admin'), deleteOrder);

module.exports = router;

