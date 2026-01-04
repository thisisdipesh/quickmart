const express = require('express');
const router = express.Router();
const {
  getAllOrders,
  updateOrderStatusOnly,
} = require('../controllers/orderController');
const { protect, authorize } = require('../middleware/authMiddleware');

// @route   GET /api/admin/orders
// @access  Private/Admin
router.get('/orders', protect, authorize('admin'), getAllOrders);

// @route   PATCH /api/admin/orders/:id/status
// @access  Private/Admin
router.patch(
  '/orders/:id/status',
  protect,
  authorize('admin'),
  async (req, res, next) => {
    try {
      // Map status from request body to orderStatus
      const { status } = req.body;
      if (status) {
        req.body.orderStatus = status;
      }
      await updateOrderStatusOnly(req, res, next);
    } catch (error) {
      next(error);
    }
  }
);

module.exports = router;

