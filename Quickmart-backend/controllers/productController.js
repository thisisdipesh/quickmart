const Product = require('../models/Product');
const Category = require('../models/Category');
const path = require('path');

// @desc    Create new product
// @route   POST /api/products
// @access  Private/Admin
exports.createProduct = async (req, res) => {
  try {
    console.log('=== Creating Product ===');
    console.log('Request body keys:', Object.keys(req.body));
    console.log('Request file:', req.file);
    console.log('Request files:', req.files);
    
    // Parse FormData values (they come as strings)
    const name = req.body.name;
    const price = parseFloat(req.body.price);
    const description = req.body.description;
    const category = req.body.category;
    const stock = parseInt(req.body.stock, 10);
    const rating = req.body.rating ? parseFloat(req.body.rating) : 0;
    const isFeatured = req.body.isFeatured === 'true' || req.body.isFeatured === true;

    // Validate required fields
    if (!name || name.trim().length < 2) {
      return res.status(400).json({
        success: false,
        message: 'Product name must be at least 2 characters',
      });
    }

    if (!price || isNaN(price) || price < 0) {
      return res.status(400).json({
        success: false,
        message: 'Please provide a valid price (must be a number >= 0)',
      });
    }

    if (!description || description.trim().length < 2) {
      return res.status(400).json({
        success: false,
        message: 'Product description must be at least 2 characters',
      });
    }

    if (!category) {
      return res.status(400).json({
        success: false,
        message: 'Please select a category',
      });
    }

    if (stock === undefined || isNaN(stock) || stock < 0) {
      return res.status(400).json({
        success: false,
        message: 'Please provide a valid stock quantity (must be a number >= 0)',
      });
    }

    // Check if category exists
    const categoryExists = await Category.findById(category);
    if (!categoryExists) {
      return res.status(404).json({
        success: false,
        message: 'Category not found',
      });
    }

    // Handle image upload
    let imageUrl = '';
    if (req.file) {
      console.log('Image file received:', req.file.filename, req.file.path);
      imageUrl = `/uploads/product_images/${req.file.filename}`;
      console.log('Image URL saved:', imageUrl);
    } else {
      console.log('No image file received in request');
      console.log('Request files:', req.files);
      console.log('Request body keys:', Object.keys(req.body));
    }

    const productData = {
      name,
      price,
      description,
      category,
      imageUrl,
      stock,
      rating: rating || 0,
      isFeatured: isFeatured || false,
    };
    
    console.log('Creating product with data:', productData);
    const product = await Product.create(productData);

    await product.populate('category', 'name iconUrl');

    console.log('Product created successfully with imageUrl:', product.imageUrl);

    res.status(201).json({
      success: true,
      message: 'Product created successfully',
      data: { product },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Get all products
// @route   GET /api/products
// @access  Public
exports.getAllProducts = async (req, res) => {
  try {
    const {
      category,
      search,
      featured,
      page = 1,
      limit = 10,
      sort = '-createdAt',
    } = req.query;

    // Build query
    const query = {};

    if (category) {
      query.category = category;
    }

    if (search) {
      query.$text = { $search: search };
    }

    if (featured === 'true') {
      query.isFeatured = true;
    }

    // Pagination
    const pageNum = parseInt(page);
    const limitNum = parseInt(limit);
    const skip = (pageNum - 1) * limitNum;

    const products = await Product.find(query)
      .populate('category', 'name iconUrl')
      .sort(sort)
      .skip(skip)
      .limit(limitNum);

    const total = await Product.countDocuments(query);

    res.status(200).json({
      success: true,
      count: products.length,
      total,
      page: pageNum,
      pages: Math.ceil(total / limitNum),
      data: { products },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Get products by category
// @route   GET /api/products/category/:categoryId
// @access  Public
exports.getProductsByCategory = async (req, res) => {
  try {
    const { categoryId } = req.params;

    const products = await Product.find({ category: categoryId }).populate(
      'category',
      'name iconUrl'
    );

    res.status(200).json({
      success: true,
      count: products.length,
      data: { products },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Get single product
// @route   GET /api/products/:id
// @access  Public
exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).populate(
      'category',
      'name iconUrl'
    );

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }

    res.status(200).json({
      success: true,
      data: { product },
    });
  } catch (error) {
    if (error.name === 'CastError') {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Update product
// @route   PUT /api/products/:id
// @access  Private/Admin
exports.updateProduct = async (req, res) => {
  try {
    let product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }

    // Handle image upload
    if (req.file) {
      req.body.imageUrl = `/uploads/product_images/${req.file.filename}`;
    }

    // Parse FormData values if they exist
    const updateData = { ...req.body };
    if (req.body.price) updateData.price = parseFloat(req.body.price);
    if (req.body.stock) updateData.stock = parseInt(req.body.stock, 10);
    if (req.body.rating) updateData.rating = parseFloat(req.body.rating);
    if (req.body.isFeatured !== undefined) {
      updateData.isFeatured = req.body.isFeatured === 'true' || req.body.isFeatured === true;
    }

    // Check if category is being updated and exists
    if (updateData.category) {
      const categoryExists = await Category.findById(updateData.category);
      if (!categoryExists) {
        return res.status(404).json({
          success: false,
          message: 'Category not found',
        });
      }
    }

    product = await Product.findByIdAndUpdate(req.params.id, updateData, {
      new: true,
      runValidators: true,
    }).populate('category', 'name iconUrl');

    res.status(200).json({
      success: true,
      message: 'Product updated successfully',
      data: { product },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
};

// @desc    Delete product
// @route   DELETE /api/products/:id
// @access  Private/Admin
exports.deleteProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }

    await product.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Product deleted successfully',
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






