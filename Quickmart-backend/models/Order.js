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
    total: {
      type: Number,
      required: true,
      min: 0,
    },
    paymentMethod: {
      type: String,
      required: true,
      enum: ['Khalti', 'Cash on Delivery', 'Credit Card', 'Debit Card'],
      default: 'Cash on Delivery',
    },
    location: {
      lat: {
        type: Number,
        required: true,
      },
      lng: {
        type: Number,
        required: true,
      },
    },
    orderStatus: {
      type: String,
      enum: ['placed', 'gathering', 'picked', 'on_the_way', 'delivered'],
      default: 'placed',
    },
    // Keep existing fields for backward compatibility
    shippingAddress: {
      name: {
        type: String,
        required: false,
      },
      phone: {
        type: String,
        required: false,
      },
      address: {
        type: String,
        required: false,
      },
      city: {
        type: String,
        required: false,
      },
      postalCode: {
        type: String,
        required: false,
      },
    },
    paymentStatus: {
      type: String,
      enum: ['Pending', 'Paid', 'Failed'],
      default: 'Pending',
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

