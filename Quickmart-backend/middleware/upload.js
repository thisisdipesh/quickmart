const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Ensure upload directories exist
const productImagesDir = path.join(__dirname, '../uploads/product_images');
const categoryIconsDir = path.join(__dirname, '../uploads/category_icons');

[productImagesDir, categoryIconsDir].forEach((dir) => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

// Storage configuration for product images
const productStorage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, productImagesDir);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(
      null,
      'product-' + uniqueSuffix + path.extname(file.originalname)
    );
  },
});

// Storage configuration for category icons
const categoryStorage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, categoryIconsDir);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(
      null,
      'category-' + uniqueSuffix + path.extname(file.originalname)
    );
  },
});

// File filter
const fileFilter = (req, file, cb) => {
  // Accept images only
  if (file.mimetype.startsWith('image')) {
    cb(null, true);
  } else {
    cb(new Error('Only image files are allowed'), false);
  }
};

// Multer configuration for product images
exports.uploadProductImage = multer({
  storage: productStorage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
  },
  fileFilter: fileFilter,
});

// Multer configuration for category icons
exports.uploadCategoryIcon = multer({
  storage: categoryStorage,
  limits: {
    fileSize: 2 * 1024 * 1024, // 2MB
  },
  fileFilter: fileFilter,
});






