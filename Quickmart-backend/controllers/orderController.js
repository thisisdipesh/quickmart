const Order = require('../models/Order');

// Helper function to calculate progress based on order status
const getProgressFromStatus = (status) => {
  const statusProgress = {
    'placed': 20,
    'gathering': 40,
    'picked': 60,
    'on_the_way': 80,
    'delivered': 100,
    // Legacy format support
    'Order Placed': 20,
    'Gathering Items': 40,
    'Picked Up': 60,
    'On The Way': 80,
    'Delivered': 100,
  };
  return statusProgress[status] || 20;
};

// @desc    Create new order
// @route   POST /api/orders
// @access  Private
exports.createOrder = async (req, res) => {
  try {
    const {
      items,
      totalAmount,
      paymentMethod,
      location,
      shippingAddress,
      subtotal,
      discount,
      deliveryCharges,
      total,
    } = req.body;

    // Support both new format (totalAmount, location) and old format (total, shippingAddress)
    const orderData = {
      user: req.user.id,
      items,
      paymentMethod: paymentMethod || 'Cash on Delivery',
      orderStatus: 'placed',
    };

    // New format with location
    if (location && location.lat && location.lng) {
      orderData.location = {
        lat: location.lat,
        lng: location.lng,
      };
    }

    // Support both totalAmount and total
    if (totalAmount) {
      orderData.total = totalAmount;
    } else if (total) {
      orderData.total = total;
    } else {
      return res.status(400).json({
        success: false,
        message: 'Total amount is required',
      });
    }

    // Legacy shippingAddress support
    if (shippingAddress) {
      orderData.shippingAddress = shippingAddress;
    }

    // Legacy subtotal, discount, deliveryCharges support
    if (subtotal !== undefined) orderData.subtotal = subtotal;
    if (discount !== undefined) orderData.discount = discount || 0;
    if (deliveryCharges !== undefined) orderData.deliveryCharges = deliveryCharges || 0;

    // Payment status
    orderData.paymentStatus = paymentMethod === 'Khalti' ? 'Paid' : 'Pending';

    const order = await Order.create(orderData);

    res.status(201).json({
      success: true,
      message: 'Order created successfully',
      data: {
        order,
        orderId: order._id,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Get all orders
// @route   GET /api/orders
// @access  Private/Admin
exports.getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find().sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: orders.length,
      data: { orders },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Get single order
// @route   GET /api/orders/:id
// @access  Private
exports.getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    // Check if user owns the order or is admin
    if (order.user._id.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to access this order',
      });
    }

    // Return clean order data format
    const orderData = {
      orderId: order._id,
      id: order._id,
      _id: order._id,
      items: order.items.map((item) => ({
        productId: item.product?._id || item.product,
        name: item.name || item.product?.name || 'Product',
        price: item.price,
        quantity: item.quantity,
        imageUrl: item.image || item.product?.imageUrl,
        image: item.image || item.product?.imageUrl,
        product: item.product,
      })),
      totalAmount: order.total,
      total: order.total,
      status: order.orderStatus,
      orderStatus: order.orderStatus,
      driverName: order.driverName || null,
      location: {
        lat: order.location?.lat || 0,
        lng: order.location?.lng || 0,
      },
      createdAt: order.createdAt,
      deliveryTime: order.deliveryTime || null,
      progress: order.progress || getProgressFromStatus(order.orderStatus),
      paymentMethod: order.paymentMethod,
      paymentStatus: order.paymentStatus,
    };

    res.status(200).json({
      success: true,
      data: orderData,
    });
  } catch (error) {
    if (error.name === 'CastError') {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Get orders by user
// @route   GET /api/orders/user/my-orders
// @access  Private
exports.getMyOrders = async (req, res) => {
  try {
    const orders = await Order.find({ user: req.user.id }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: orders.length,
      data: { orders },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Get user orders with status filter
// @route   GET /api/orders/my
// @access  Private
exports.getMyOrdersWithFilter = async (req, res) => {
  try {
    const { status } = req.query;
    
    // Build query
    let query = { user: req.user.id };

    // Filter by status
    if (status) {
      switch (status) {
        case 'active':
          // Active orders: placed, gathering, picked, on_the_way
          query.orderStatus = { $in: ['placed', 'gathering', 'picked', 'on_the_way'] };
          break;
        case 'completed':
          // Completed orders: delivered
          query.orderStatus = 'delivered';
          break;
        case 'cancel':
          // Cancelled orders
          query.orderStatus = { $in: ['cancelled', 'Cancelled'] };
          break;
        default:
          // No filter, return all
          break;
      }
    }

    const orders = await Order.find(query).sort({ createdAt: -1 });

    // Format orders for response
    const formattedOrders = orders.map((order) => ({
      orderId: order._id,
      id: order._id,
      _id: order._id,
      items: order.items.map((item) => ({
        productId: item.product?._id || item.product,
        name: item.name || item.product?.name || 'Product',
        price: item.price,
        quantity: item.quantity,
        imageUrl: item.image || item.product?.imageUrl,
        image: item.image || item.product?.imageUrl,
        product: item.product,
      })),
      totalAmount: order.total,
      total: order.total,
      status: order.orderStatus,
      orderStatus: order.orderStatus,
      createdAt: order.createdAt,
      location: order.location || { lat: 0, lng: 0 },
      driverName: order.driverName || null,
      deliveryTime: order.deliveryTime || null,
      progress: order.progress || getProgressFromStatus(order.orderStatus),
    }));

    res.status(200).json({
      success: true,
      count: formattedOrders.length,
      data: { orders: formattedOrders },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Update order status
// @route   PUT /api/orders/:id
// @access  Private/Admin
exports.updateOrderStatus = async (req, res) => {
  try {
    const { orderStatus, paymentStatus, driverName, deliveryTime } = req.body;

    let order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    const updateData = {};
    if (orderStatus) {
      updateData.orderStatus = orderStatus;
      // Automatically calculate progress based on status
      updateData.progress = getProgressFromStatus(orderStatus);
    }
    if (paymentStatus) updateData.paymentStatus = paymentStatus;
    if (driverName !== undefined) updateData.driverName = driverName;
    if (deliveryTime !== undefined) updateData.deliveryTime = deliveryTime;

    order = await Order.findByIdAndUpdate(req.params.id, updateData, {
      new: true,
      runValidators: true,
    });

    res.status(200).json({
      success: true,
      message: 'Order updated successfully',
      data: { order },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Update order status (dedicated endpoint)
// @route   PUT /api/orders/:id/status
// @access  Private/Admin
exports.updateOrderStatusOnly = async (req, res) => {
  try {
    const { orderStatus, driverName, deliveryTime } = req.body;

    let order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    // Calculate progress based on status
    const progress = getProgressFromStatus(orderStatus);

    const updateData = {
      orderStatus,
      progress,
    };

    if (driverName !== undefined) updateData.driverName = driverName;
    if (deliveryTime !== undefined) updateData.deliveryTime = deliveryTime;

    order = await Order.findByIdAndUpdate(req.params.id, updateData, {
      new: true,
      runValidators: true,
    });

    res.status(200).json({
      success: true,
      message: 'Order status updated successfully',
      data: { order },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Delete order
// @route   DELETE /api/orders/:id
// @access  Private/Admin
exports.deleteOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    await order.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Order deleted successfully',
      data: {},
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

