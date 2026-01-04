const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Category = require('../models/Category');

// Load env vars
dotenv.config();

// Connect to database
const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/quickmart');
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error('Error connecting to MongoDB:', error);
    process.exit(1);
  }
};

const categories = [
  'Fresh & Perishables',
  'Meat, Fish & Poultry',
  'Dairy & Eggs',
  'Bakery',
  'Staples & Grains',
  'Packaged Food',
  'Spices & Condiments',
  'Snacks & Confectionery',
  'Beverages',
  'Frozen Foods',
  'Personal Care & Beauty',
  'Household & Cleaning',
  'Baby Care',
  'Paper & Hygiene',
  'Health & Wellness',
  'Pet Care',
  'Kitchen & Home Essentials',
  'Home & Living',
];

const seedCategories = async () => {
  try {
    await connectDB();

    // Clear existing categories (optional - comment out if you want to keep existing)
    // await Category.deleteMany({});

    // Insert categories
    for (const categoryName of categories) {
      const existingCategory = await Category.findOne({
        name: { $regex: new RegExp(`^${categoryName}$`, 'i') },
      });

      if (!existingCategory) {
        await Category.create({
          name: categoryName,
          iconUrl: '',
        });
        console.log(`Created category: ${categoryName}`);
      } else {
        console.log(`Category already exists: ${categoryName}`);
      }
    }

    console.log('\n✅ Categories seeded successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding categories:', error);
    process.exit(1);
  }
};

seedCategories();



