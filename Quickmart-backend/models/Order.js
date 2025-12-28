const mongoose = require('mongoose');

const orderItemSchema = new mongoose.Schema({
  product: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true,
  },
  quantity: {
    type: Number,
    required: true,
    min: 1,
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  // Store product details for easier display (optional)
  name: {
    type: String,
  },
  image: {
    type: String,
  },
});

const orderSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    items: [orderItemSchema],
    shippingAddress: {
      name: {
        type: String,
        required: true,
      },
      phone: {
        type: String,
        required: true,
      },
      address: {
        type: String,
        required: true,
      },
      city: {
        type: String,
        required: true,
      },
      postalCode: {
        type: String,
        required: false,
      },
    },
    paymentMethod: {
      type: String,
      required: true,
      enum: ['Khalti', 'Cash on Delivery', 'Credit Card', 'Debit Card'],
      default: 'Cash on Delivery',
    },
    paymentStatus: {
      type: String,
      enum: ['Pending', 'Paid', 'Failed'],
      default: 'Pending',
    },
    orderStatus: {
      type: String,
      enum: [
        'Order Placed',
        'Gathering Items',
        'Picked Up',
        'On The Way',
        'Delivered',
      ],
      default: 'Order Placed',
    },
    progress: {
      type: Number,
      default: 20,
      min: 0,
      max: 100,
    },
    driverName: {
      type: String,
      default: '',
    },
    deliveryTime: {
      type: String,
      default: '',
    },
    subtotal: {
      type: Number,
      required: true,
      min: 0,
    },
    discount: {
      type: Number,
      default: 0,
      min: 0,
    },
    deliveryCharges: {
      type: Number,
      default: 0,
      min: 0,
    },
    total: {
      type: Number,
      required: true,
      min: 0,
    },
  },
  {
    timestamps: true,
  }
);

// Populate product details in items
orderSchema.pre(/^find/, function (next) {
  this.populate({
    path: 'items.product',
    select: 'name price imageUrl',
  });
  this.populate({
    path: 'user',
    select: 'name email phone',
  });
  next();
});

module.exports = mongoose.model('Order', orderSchema);

