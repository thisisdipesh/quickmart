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
          product: Joi.string().required(),
          quantity: Joi.number().integer().min(1).required(),
          price: Joi.number().min(0).required(),
        })
      )
      .min(1)
      .required(),
    shippingAddress: Joi.object({
      name: Joi.string().required(),
      phone: Joi.string().required(),
      address: Joi.string().required(),
      city: Joi.string().required(),
      postalCode: Joi.string().optional(),
    }).required(),
    paymentMethod: Joi.string()
      .valid('Khalti', 'Cash on Delivery', 'Credit Card', 'Debit Card')
      .optional(),
    subtotal: Joi.number().min(0).required(),
    discount: Joi.number().min(0).optional(),
    deliveryCharges: Joi.number().min(0).optional(),
    total: Joi.number().min(0).required(),
  }),

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






