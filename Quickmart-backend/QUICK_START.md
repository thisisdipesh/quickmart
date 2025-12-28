# Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Install Dependencies
```bash
npm install
```

### Step 2: Setup Environment Variables

Create a `.env` file in the root directory:

```env
PORT=5000
NODE_ENV=development
MONGO_URI=mongodb://localhost:27017/quickmart
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_EXPIRE=7d
CORS_ORIGIN=http://localhost:3000
```

**Important:** Change `JWT_SECRET` to a strong random string in production!

### Step 3: Start MongoDB

Make sure MongoDB is running on your system:
- **Windows:** MongoDB should be running as a service
- **Mac/Linux:** `sudo systemctl start mongod` or `brew services start mongodb-community`

### Step 4: Run the Server

```bash
# Development mode (auto-restart on changes)
npm run dev

# Production mode
npm start
```

You should see:
```
MongoDB Connected: localhost:27017
Server running in development mode on port 5000
```

### Step 5: Test the API

Open your browser or use Postman:
```
GET http://localhost:5000/health
```

Expected response:
```json
{
  "success": true,
  "message": "QuickMart API is running",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

## 📝 First Steps

### 1. Register an Admin User

```bash
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "name": "Admin User",
  "email": "admin@quickmart.com",
  "password": "admin123",
  "role": "admin"
}
```

### 2. Login to Get Token

```bash
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "admin@quickmart.com",
  "password": "admin123"
}
```

Save the `token` from the response!

### 3. Create a Category

```bash
POST http://localhost:5000/api/categories
Authorization: Bearer <your_token>
Content-Type: multipart/form-data

name: Electronics
icon: [upload image file]
```

### 4. Create a Product

```bash
POST http://localhost:5000/api/products
Authorization: Bearer <your_token>
Content-Type: multipart/form-data

name: iPhone 15
price: 999.99
description: Latest iPhone model
category: <category_id_from_step_3>
stock: 50
isFeatured: true
image: [upload image file]
```

## 🎯 Common Issues

### MongoDB Connection Error
- Make sure MongoDB is installed and running
- Check your `MONGO_URI` in `.env`
- Default: `mongodb://localhost:27017/quickmart`

### Port Already in Use
- Change `PORT` in `.env` to a different port (e.g., 5001)
- Or stop the process using port 5000

### JWT Token Invalid
- Make sure you're including `Bearer ` prefix: `Authorization: Bearer <token>`
- Token might be expired, login again to get a new token

### File Upload Errors
- Check file size (products: 5MB max, categories: 2MB max)
- Only image files are allowed
- Upload directories are created automatically

## 📚 Next Steps

- Read the full [README.md](./README.md) for detailed documentation
- Check [API_EXAMPLES.md](./API_EXAMPLES.md) for more API examples
- Integrate with your Flutter frontend

## 🔗 Useful Links

- [Express.js Documentation](https://expressjs.com/)
- [Mongoose Documentation](https://mongoosejs.com/)
- [JWT.io](https://jwt.io/) - JWT token decoder

Happy coding! 🎉






