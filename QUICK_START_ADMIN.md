# Quick Start Guide - Admin Dashboard

## 🚀 How to Run the Admin Dashboard

### Prerequisites
1. ✅ MongoDB must be running
2. ✅ Node.js installed
3. ✅ Backend server must be running

---

## 📋 Step-by-Step Instructions

### Step 1: Start MongoDB
Make sure MongoDB is running on your system:
- **Windows**: Check if MongoDB service is running
- **Mac/Linux**: `sudo systemctl start mongod` or `brew services start mongodb-community`

### Step 2: Start the Backend Server (Terminal 1)

```bash
# Navigate to backend directory
cd Quickmart-backend

# Start the server
npm run dev
```

**Expected Output:**
```
Server running in development mode on port 5000
MongoDB Connected: localhost:27017
```

✅ **Keep this terminal running!**

---

### Step 3: Start the Admin Dashboard (Terminal 2)

Open a **NEW terminal window** and run:

```bash
# Navigate to admin dashboard directory
cd quickmart-admin

# Start the development server
npm run dev
```

**Expected Output:**
```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

✅ **Keep this terminal running too!**

---

### Step 4: Access the Admin Dashboard

1. Open your web browser
2. Navigate to: **http://localhost:5173**
3. You should see the **Login page**

---

### Step 5: Login as Admin

**Default Admin Credentials:**
- **Email**: `admin@quickmart.com`
- **Password**: `admin123`

*(These were created earlier. If you don't have an admin user, see "Creating Admin User" below)*

---

## 🔐 Creating an Admin User (If Needed)

If you don't have an admin user yet, create one:

### Option 1: Using PowerShell/Command Line

```powershell
# In PowerShell
$body = @{
    name = "Admin User"
    email = "admin@quickmart.com"
    password = "admin123"
    role = "admin"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/auth/register" -Method Post -Body $body -ContentType "application/json"
```

### Option 2: Using Postman/API Client

```http
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "name": "Admin User",
  "email": "admin@quickmart.com",
  "password": "admin123",
  "role": "admin"
}
```

---

## 📊 What You'll See

After logging in, you'll have access to:

1. **Dashboard** - Statistics overview
2. **Products** - Manage all products
3. **Categories** - Manage categories
4. **Users** - View all users

---

## ⚠️ Troubleshooting

### Admin Dashboard shows "Network Error"
- ✅ Check if backend is running on port 5000
- ✅ Verify `.env` file has correct API URL: `VITE_API_URL=http://localhost:5000/api`
- ✅ Check browser console for errors

### Backend won't start
- ✅ Check if MongoDB is running
- ✅ Verify `.env` file exists in `Quickmart-backend` directory
- ✅ Check if port 5000 is already in use

### Login fails
- ✅ Verify admin user exists in database
- ✅ Check user role is set to "admin"
- ✅ Verify backend is running and accessible

### Admin Dashboard is blank
- ✅ Check browser console for JavaScript errors
- ✅ Verify all dependencies are installed: `npm install`
- ✅ Try clearing browser cache

---

## 🔄 Running Both Services

You need **TWO terminal windows**:

**Terminal 1 (Backend):**
```bash
cd Quickmart-backend
npm run dev
```

**Terminal 2 (Admin Dashboard):**
```bash
cd quickmart-admin
npm run dev
```

Both must be running simultaneously!

---

## 🌐 URLs

- **Backend API**: http://localhost:5000
- **Admin Dashboard**: http://localhost:5173
- **API Health Check**: http://localhost:5000/health

---

## ✅ Quick Checklist

- [ ] MongoDB is running
- [ ] Backend server is running (Terminal 1)
- [ ] Admin dashboard is running (Terminal 2)
- [ ] Admin user exists in database
- [ ] Can access http://localhost:5173
- [ ] Can login with admin credentials

---

Happy Admin-ing! 🎉


