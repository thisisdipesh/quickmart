const Joi = require('joi');

// Validation schemas
const schemas = {
  // Auth validation
  register: Joi.object({
    name: Joi.string().min(2).max(50).required(),
    email: Joi.string().email().required(),
    password: Joi.string().min(6).required(),
    phone: Joi.string().optional(),
    role: Joi.string().valid('admin', 'customer').optional(),
  }),

  login: Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().required(),
  }),

  // Product validation
  createProduct: Joi.object({
    name: Joi.string().min(2).max(100).required(),
    price: Joi.number().min(0).required(),
    description: Joi.string().min(10).required(),
    category: Joi.string().required(),
    stock: Joi.number().min(0).integer().required(),
    rating: Joi.number().min(0).max(5).optional(),
    isFeatured: Joi.boolean().optional(),
  }),

  updateProduct: Joi.object({
    name: Joi.string().min(2).max(100).optional(),
    price: Joi.number().min(0).optional(),
    description: Joi.string().min(10).optional(),
    category: Joi.string().optional(),
    stock: Joi.number().min(0).integer().optional(),
    rating: Joi.number().min(0).max(5).optional(),
    isFeatured: Joi.boolean().optional(),
  }),

  // Category validation
  createCategory: Joi.object({
    name: Joi.string().min(2).max(50).required(),
  }),

  updateCategory: Joi.object({
    name: Joi.string().min(2).max(50).optional(),
  }),

  // User validation
  updateUser: Joi.object({
    name: Joi.string().min(2).max(50).optional(),
    phone: Joi.string().optional(),
  }),

  // Order validation
  createOrder: Joi.object({
    items: Joi.array()
      .items(
        Joi.object({
          productId: Joi.string().optional(),
          product: Joi.string().optional(),
          name: Joi.string().optional(),
          price: Joi.number().min(0).required(),
          quantity: Joi.number().integer().min(1).required(),
        })
      )
      .min(1)
      .required(),
    totalAmount: Joi.number().min(0).optional(),
    total: Joi.number().min(0).optional(),
    paymentMethod: Joi.string()
      .valid('Khalti', 'Cash on Delivery', 'Credit Card', 'Debit Card')
      .optional(),
    location: Joi.object({
      lat: Joi.number().required(),
      lng: Joi.number().required(),
    }).optional(),
    shippingAddress: Joi.object({
      name: Joi.string().optional(),
      phone: Joi.string().optional(),
      address: Joi.string().optional(),
      city: Joi.string().optional(),
      postalCode: Joi.string().optional(),
    }).optional(),
    subtotal: Joi.number().min(0).optional(),
    discount: Joi.number().min(0).optional(),
    deliveryCharges: Joi.number().min(0).optional(),
  }).or('totalAmount', 'total'),

  updateOrder: Joi.object({
    orderStatus: Joi.string()
      .valid('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')
      .optional(),
    paymentStatus: Joi.string().valid('Pending', 'Paid', 'Failed').optional(),
  }),
};

// Validation middleware
exports.validate = (schema) => {
  return (req, res, next) => {
    const { error } = schemas[schema].validate(req.body, {
      abortEarly: false,
    });

    if (error) {
      const errors = error.details.map((detail) => detail.message);
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        errors,
      });
    }

    next();
  };
};






