# QuickMart Admin Dashboard

A modern, responsive admin dashboard built with React.js and Vite for managing QuickMart e-commerce platform.

## 🚀 Features

- **JWT Authentication** - Secure admin login
- **Product Management** - Add, edit, delete, and manage products with image upload
- **Category Management** - Create and manage product categories with icons
- **User Management** - View all registered users
- **Dashboard** - Overview with statistics and metrics
- **Responsive Design** - Works on desktop and tablet devices
- **Modern UI** - Built with Tailwind CSS

## 📁 Project Structure

```
quickmart-admin/
├── src/
│   ├── components/
│   │   ├── Navbar.jsx
│   │   ├── ProtectedRoute.jsx
│   │   └── Sidebar.jsx
│   ├── pages/
│   │   ├── Dashboard.jsx
│   │   ├── Login.jsx
│   │   ├── Products.jsx
│   │   ├── AddProduct.jsx
│   │   ├── EditProduct.jsx
│   │   ├── Categories.jsx
│   │   └── Users.jsx
│   ├── services/
│   │   └── api.js
│   ├── App.jsx
│   └── main.jsx
├── .env
└── package.json
```

## 🛠️ Installation

1. **Install dependencies:**
```bash
npm install
```

2. **Configure environment variables:**
Create a `.env` file in the root directory:
```env
VITE_API_URL=http://localhost:5000/api
```

3. **Start the development server:**
```bash
npm run dev
```

The admin dashboard will be available at `http://localhost:5173`

## 🔐 Authentication

### Default Admin Credentials

After setting up the backend, create an admin user:

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

Then login with these credentials in the admin dashboard.

## 📚 API Integration

The dashboard connects to the QuickMart backend API. Make sure the backend server is running on `http://localhost:5000`.

### API Endpoints Used

- **Auth:** `/api/auth/login`
- **Products:** `/api/products` (GET, POST, PUT, DELETE)
- **Categories:** `/api/categories` (GET, POST, DELETE)
- **Users:** `/api/users` (GET)

## 🎨 Features Overview

### Dashboard
- Overview statistics (Total Products, Categories, Users, Featured Products)
- Quick access to all sections

### Products Management
- View all products in a table
- Add new products with image upload
- Edit existing products
- Delete products
- Filter and search capabilities

### Categories Management
- View all categories in a grid
- Add new categories with icon upload
- Delete categories

### Users Management
- View all registered users
- See user details (name, email, role, etc.)

## 🛡️ Security

- JWT token-based authentication
- Protected routes (admin-only access)
- Automatic token refresh handling
- Secure API communication

## 📦 Build for Production

```bash
npm run build
```

The built files will be in the `dist` directory.

## 🔧 Technologies Used

- **React 19** - UI library
- **Vite** - Build tool and dev server
- **React Router** - Routing
- **Axios** - HTTP client
- **Tailwind CSS** - Styling

## 📝 Notes

- Make sure MongoDB is running
- Backend server must be running on port 5000
- Image uploads are handled via multipart/form-data
- All admin routes require authentication

## 🐛 Troubleshooting

### Cannot connect to API
- Check if backend server is running
- Verify `VITE_API_URL` in `.env` file
- Check CORS settings in backend

### Login fails
- Verify admin user exists in database
- Check user role is set to "admin"
- Verify JWT_SECRET in backend .env

### Images not loading
- Check backend uploads directory exists
- Verify image URLs in API responses
- Check CORS allows image requests

## 📄 License

ISC
