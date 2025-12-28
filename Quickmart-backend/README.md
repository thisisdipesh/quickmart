# QuickMart Backend API

Complete RESTful API backend for QuickMart e-commerce application built with Node.js, Express.js, and MongoDB.

## 🚀 Features

- **JWT Authentication** - Secure user authentication and authorization
- **Role-based Access Control** - Admin and Customer roles
- **Product Management** - CRUD operations for products with image upload
- **Category Management** - CRUD operations for categories with icon upload
- **User Management** - Profile management and admin user listing
- **Image Upload** - Multer-based file upload for products and categories
- **Security** - Helmet, CORS, Rate Limiting, Input Validation
- **MongoDB Integration** - Mongoose ODM with proper schemas

## 📁 Project Structure

```
/backend
    /config
        db.js                 # MongoDB connection
    /controllers
        authController.js     # Authentication logic
        productController.js  # Product CRUD operations
        categoryController.js # Category CRUD operations
        userController.js     # User management
    /models
        User.js              # User schema
        Product.js           # Product schema
        Category.js          # Category schema
    /routes
        authRoutes.js        # Auth endpoints
        productRoutes.js     # Product endpoints
        categoryRoutes.js   # Category endpoints
        userRoutes.js       # User endpoints
    /middleware
        authMiddleware.js    # JWT authentication & authorization
        upload.js           # Multer file upload config
        validation.js       # Joi validation schemas
    /uploads
        product_images/     # Product image storage
        category_icons/     # Category icon storage
    server.js              # Express app entry point
    .env                   # Environment variables
    package.json           # Dependencies
```

## 🛠️ Installation

1. **Install dependencies:**
```bash
npm install
```

2. **Create `.env` file:**
```bash
cp .env.example .env
```

3. **Configure environment variables:**
```env
PORT=5000
NODE_ENV=development
MONGO_URI=mongodb://localhost:27017/quickmart
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_EXPIRE=7d
CORS_ORIGIN=http://localhost:3000
```

4. **Start MongoDB:**
Make sure MongoDB is running on your system.

5. **Run the server:**
```bash
# Development mode (with nodemon)
npm run dev

# Production mode
npm start
```

## 📚 API Endpoints

### Authentication (`/api/auth`)

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| POST | `/register` | Register new user | Public |
| POST | `/login` | Login user | Public |
| GET | `/profile` | Get current user profile | Private |

### Products (`/api/products`)

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/` | Get all products (with filters) | Public |
| GET | `/category/:categoryId` | Get products by category | Public |
| GET | `/:id` | Get single product | Public |
| POST | `/` | Create new product | Admin |
| PUT | `/:id` | Update product | Admin |
| DELETE | `/:id` | Delete product | Admin |

**Query Parameters for GET `/`:**
- `category` - Filter by category ID
- `search` - Search products by name/description
- `featured` - Filter featured products (true/false)
- `page` - Page number (default: 1)
- `limit` - Items per page (default: 10)
- `sort` - Sort field (default: -createdAt)

### Categories (`/api/categories`)

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/` | Get all categories | Public |
| GET | `/:id` | Get single category | Public |
| POST | `/` | Create new category | Admin |
| PUT | `/:id` | Update category | Admin |
| DELETE | `/:id` | Delete category | Admin |

### Users (`/api/users`)

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/` | Get all users | Admin |
| GET | `/me` | Get current user profile | Private |
| PUT | `/me` | Update current user profile | Private |

## 🔐 Authentication

All protected routes require a JWT token in the Authorization header:

```
Authorization: Bearer <token>
```

## 📤 File Upload

### Product Image Upload
- Field name: `image`
- Max size: 5MB
- Allowed types: Images only
- Storage: `/uploads/product_images/`

### Category Icon Upload
- Field name: `icon`
- Max size: 2MB
- Allowed types: Images only
- Storage: `/uploads/category_icons/`

## 📝 Sample API Requests

### Register User
```bash
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "1234567890",
  "role": "customer"
}
```

### Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

### Create Product (Admin)
```bash
POST /api/products
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "name": "iPhone 15",
  "price": 999.99,
  "description": "Latest iPhone model",
  "category": "<category_id>",
  "stock": 50,
  "isFeatured": true
}
+ image file
```

### Get All Products
```bash
GET /api/products?page=1&limit=10&featured=true
```

### Create Category (Admin)
```bash
POST /api/categories
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "name": "Electronics"
}
+ icon file
```

## 🧪 Testing

Use Postman, Insomnia, or curl to test the API endpoints. Make sure to:
1. Register a user first
2. Login to get JWT token
3. Use the token for protected routes

## 🔒 Security Features

- **Helmet** - Sets various HTTP headers for security
- **CORS** - Cross-Origin Resource Sharing configuration
- **Rate Limiting** - Prevents abuse (100 requests per 15 minutes)
- **JWT Authentication** - Secure token-based authentication
- **Input Validation** - Joi schema validation
- **Password Hashing** - bcrypt for secure password storage
- **Role-based Authorization** - Admin-only routes protection

## 📦 Dependencies

- **express** - Web framework
- **mongoose** - MongoDB ODM
- **jsonwebtoken** - JWT authentication
- **bcryptjs** - Password hashing
- **multer** - File upload handling
- **dotenv** - Environment variables
- **cors** - CORS middleware
- **helmet** - Security headers
- **express-rate-limit** - Rate limiting
- **joi** - Input validation

## 🐛 Error Handling

All errors are handled consistently with the following format:

```json
{
  "success": false,
  "message": "Error message",
  "error": "Detailed error (development only)"
}
```

## 📄 License

ISC






