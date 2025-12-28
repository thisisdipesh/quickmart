# QuickMart API Examples

Sample API requests and responses for testing the backend.

## 🔐 Authentication

### 1. Register User

**Request:**
```bash
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "1234567890",
  "role": "customer"
}
```

**Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "65a1b2c3d4e5f6g7h8i9j0k1",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "1234567890",
      "role": "customer"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 2. Login

**Request:**
```bash
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "65a1b2c3d4e5f6g7h8i9j0k1",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "1234567890",
      "role": "customer"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 3. Get Profile

**Request:**
```bash
GET http://localhost:5000/api/auth/profile
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "65a1b2c3d4e5f6g7h8i9j0k1",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "1234567890",
      "role": "customer",
      "createdAt": "2024-01-15T10:30:00.000Z"
    }
  }
}
```

## 📦 Products

### 1. Create Product (Admin)

**Request:**
```bash
POST http://localhost:5000/api/products
Authorization: Bearer <admin_token>
Content-Type: multipart/form-data

name: iPhone 15
price: 999.99
description: Latest iPhone model with advanced features
category: 65a1b2c3d4e5f6g7h8i9j0k2
stock: 50
isFeatured: true
image: [file]
```

**Response:**
```json
{
  "success": true,
  "message": "Product created successfully",
  "data": {
    "product": {
      "_id": "65a1b2c3d4e5f6g7h8i9j0k3",
      "name": "iPhone 15",
      "price": 999.99,
      "description": "Latest iPhone model with advanced features",
      "category": {
        "_id": "65a1b2c3d4e5f6g7h8i9j0k2",
        "name": "Electronics",
        "iconUrl": "/uploads/category_icons/category-1234567890.png"
      },
      "imageUrl": "/uploads/product_images/product-1234567890.jpg",
      "stock": 50,
      "rating": 0,
      "isFeatured": true,
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  }
}
```

### 2. Get All Products

**Request:**
```bash
GET http://localhost:5000/api/products?page=1&limit=10&featured=true
```

**Response:**
```json
{
  "success": true,
  "count": 10,
  "total": 25,
  "page": 1,
  "pages": 3,
  "data": {
    "products": [
      {
        "_id": "65a1b2c3d4e5f6g7h8i9j0k3",
        "name": "iPhone 15",
        "price": 999.99,
        "description": "Latest iPhone model",
        "category": {
          "_id": "65a1b2c3d4e5f6g7h8i9j0k2",
          "name": "Electronics",
          "iconUrl": "/uploads/category_icons/category-1234567890.png"
        },
        "imageUrl": "/uploads/product_images/product-1234567890.jpg",
        "stock": 50,
        "rating": 4.5,
        "isFeatured": true,
        "createdAt": "2024-01-15T10:30:00.000Z"
      }
    ]
  }
}
```

### 3. Get Products by Category

**Request:**
```bash
GET http://localhost:5000/api/products/category/65a1b2c3d4e5f6g7h8i9j0k2
```

**Response:**
```json
{
  "success": true,
  "count": 5,
  "data": {
    "products": [
      {
        "_id": "65a1b2c3d4e5f6g7h8i9j0k3",
        "name": "iPhone 15",
        "price": 999.99,
        "category": {
          "name": "Electronics",
          "iconUrl": "/uploads/category_icons/category-1234567890.png"
        },
        "imageUrl": "/uploads/product_images/product-1234567890.jpg",
        "stock": 50
      }
    ]
  }
}
```

### 4. Get Single Product

**Request:**
```bash
GET http://localhost:5000/api/products/65a1b2c3d4e5f6g7h8i9j0k3
```

**Response:**
```json
{
  "success": true,
  "data": {
    "product": {
      "_id": "65a1b2c3d4e5f6g7h8i9j0k3",
      "name": "iPhone 15",
      "price": 999.99,
      "description": "Latest iPhone model with advanced features",
      "category": {
        "_id": "65a1b2c3d4e5f6g7h8i9j0k2",
        "name": "Electronics",
        "iconUrl": "/uploads/category_icons/category-1234567890.png"
      },
      "imageUrl": "/uploads/product_images/product-1234567890.jpg",
      "stock": 50,
      "rating": 4.5,
      "isFeatured": true,
      "createdAt": "2024-01-15T10:30:00.000Z"
    }
  }
}
```

### 5. Update Product (Admin)

**Request:**
```bash
PUT http://localhost:5000/api/products/65a1b2c3d4e5f6g7h8i9j0k3
Authorization: Bearer <admin_token>
Content-Type: multipart/form-data

name: iPhone 15 Pro
price: 1199.99
stock: 30
image: [file] (optional)
```

**Response:**
```json
{
  "success": true,
  "message": "Product updated successfully",
  "data": {
    "product": {
      "_id": "65a1b2c3d4e5f6g7h8i9j0k3",
      "name": "iPhone 15 Pro",
      "price": 1199.99,
      "stock": 30,
      "updatedAt": "2024-01-15T11:00:00.000Z"
    }
  }
}
```

### 6. Delete Product (Admin)

**Request:**
```bash
DELETE http://localhost:5000/api/products/65a1b2c3d4e5f6g7h8i9j0k3
Authorization: Bearer <admin_token>
```

**Response:**
```json
{
  "success": true,
  "message": "Product deleted successfully",
  "data": {}
}
```

## 📂 Categories

### 1. Create Category (Admin)

**Request:**
```bash
POST http://localhost:5000/api/categories
Authorization: Bearer <admin_token>
Content-Type: multipart/form-data

name: Electronics
icon: [file]
```

**Response:**
```json
{
  "success": true,
  "message": "Category created successfully",
  "data": {
    "category": {
      "_id": "65a1b2c3d4e5f6g7h8i9j0k2",
      "name": "Electronics",
      "iconUrl": "/uploads/category_icons/category-1234567890.png",
      "createdAt": "2024-01-15T10:30:00.000Z"
    }
  }
}
```

### 2. Get All Categories

**Request:**
```bash
GET http://localhost:5000/api/categories
```

**Response:**
```json
{
  "success": true,
  "count": 4,
  "data": {
    "categories": [
      {
        "_id": "65a1b2c3d4e5f6g7h8i9j0k2",
        "name": "Electronics",
        "iconUrl": "/uploads/category_icons/category-1234567890.png",
        "createdAt": "2024-01-15T10:30:00.000Z"
      },
      {
        "_id": "65a1b2c3d4e5f6g7h8i9j0k4",
        "name": "Clothing",
        "iconUrl": "/uploads/category_icons/category-9876543210.png",
        "createdAt": "2024-01-15T09:00:00.000Z"
      }
    ]
  }
}
```

### 3. Update Category (Admin)

**Request:**
```bash
PUT http://localhost:5000/api/categories/65a1b2c3d4e5f6g7h8i9j0k2
Authorization: Bearer <admin_token>
Content-Type: multipart/form-data

name: Electronic Devices
icon: [file] (optional)
```

**Response:**
```json
{
  "success": true,
  "message": "Category updated successfully",
  "data": {
    "category": {
      "_id": "65a1b2c3d4e5f6g7h8i9j0k2",
      "name": "Electronic Devices",
      "iconUrl": "/uploads/category_icons/category-1234567890.png",
      "updatedAt": "2024-01-15T11:00:00.000Z"
    }
  }
}
```

### 4. Delete Category (Admin)

**Request:**
```bash
DELETE http://localhost:5000/api/categories/65a1b2c3d4e5f6g7h8i9j0k2
Authorization: Bearer <admin_token>
```

**Response:**
```json
{
  "success": true,
  "message": "Category deleted successfully",
  "data": {}
}
```

## 👤 Users

### 1. Get All Users (Admin)

**Request:**
```bash
GET http://localhost:5000/api/users
Authorization: Bearer <admin_token>
```

**Response:**
```json
{
  "success": true,
  "count": 10,
  "data": {
    "users": [
      {
        "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "1234567890",
        "role": "customer",
        "createdAt": "2024-01-15T10:30:00.000Z"
      }
    ]
  }
}
```

### 2. Get Current User Profile

**Request:**
```bash
GET http://localhost:5000/api/users/me
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "1234567890",
      "role": "customer",
      "createdAt": "2024-01-15T10:30:00.000Z"
    }
  }
}
```

### 3. Update User Profile

**Request:**
```bash
PUT http://localhost:5000/api/users/me
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "John Smith",
  "phone": "9876543210"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "user": {
      "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
      "name": "John Smith",
      "email": "john@example.com",
      "phone": "9876543210",
      "role": "customer",
      "updatedAt": "2024-01-15T11:00:00.000Z"
    }
  }
}
```

## ❌ Error Responses

### Validation Error
```json
{
  "success": false,
  "message": "Validation error",
  "errors": [
    "name is required",
    "email must be a valid email"
  ]
}
```

### Authentication Error
```json
{
  "success": false,
  "message": "Not authorized to access this route"
}
```

### Not Found Error
```json
{
  "success": false,
  "message": "Product not found"
}
```

### Server Error
```json
{
  "success": false,
  "message": "Server error",
  "error": "Detailed error message (development only)"
}
```






