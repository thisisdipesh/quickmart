# 🚀 How to Run Admin Dashboard & Backend

## ✅ **YES - You MUST run both at the same time!**

The admin dashboard needs the backend API to work. Both services must run simultaneously.

---

## 📋 **Step-by-Step Instructions**

### **Step 1: Start MongoDB**
Make sure MongoDB is running on your system.

---

### **Step 2: Start Backend Server (Terminal 1)**

```powershell
# Navigate to backend
cd "Quickmart-backend"

# Start the server
npm run dev
```

**✅ Expected Output:**
```
Server running in development mode on port 5000
MongoDB Connected: localhost:27017
```

**⚠️ If you see "port already in use" error:**
```powershell
# Find and kill the process using port 5000
netstat -ano | findstr :5000
taskkill /F /PID <PID_NUMBER>
```

**Keep this terminal running!**

---

### **Step 3: Start Admin Dashboard (Terminal 2)**

Open a **NEW terminal window**:

```powershell
# Navigate to admin dashboard
cd "quickmart-admin"

# Start the admin dashboard
npm run dev
```

**✅ Expected Output:**
```
  VITE v5.x.x  ready in xxx ms
  ➜  Local:   http://localhost:5173/
```

**Keep this terminal running too!**

---

### **Step 4: Access Admin Dashboard**

1. Open browser: **http://localhost:5173**
2. Login with:
   - **Email**: `admin@quickmart.com`
   - **Password**: `admin123`

---

## 🔄 **How It Works Together**

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│  Admin Dashboard │  ────> │  Backend API     │  ────>  │   MongoDB       │
│  (localhost:5173)│  HTTP  │  (localhost:5000)│         │  (localhost:27017)│
└─────────────────┘         └──────────────────┘         └─────────────────┘
                                      │
                                      │ HTTP
                                      ▼
                              ┌─────────────────┐
                              │  Mobile App     │
                              │  (Flutter)      │
                              └─────────────────┘
```

**Flow:**
1. **Admin Dashboard** → Adds products via API → **Backend** → Saves to **MongoDB**
2. **Mobile App** → Fetches products via API → **Backend** → Reads from **MongoDB**
3. **Same Database** = Products added in admin show in mobile app! ✅

---

## 🎯 **Adding Products (Admin → Mobile App)**

### **In Admin Dashboard:**
1. Login to http://localhost:5173
2. Go to **Products** → **Add Product**
3. Fill in:
   - Product name
   - Price
   - Description
   - Category
   - Stock
   - Upload image
   - Check "Featured" if needed
4. Click **Create Product**

### **In Mobile App:**
1. Products automatically appear!
2. Featured products show at top of home screen
3. All products available in categories

**✅ Same database = Instant sync!**

---

## 🔧 **Fixes Applied**

1. ✅ **Port conflict fixed** - Killed process using port 5000
2. ✅ **MongoDB connection fixed** - Removed deprecated options
3. ✅ **CORS fixed** - Now allows admin dashboard (localhost:5173) and mobile app
4. ✅ **API integration** - Admin dashboard connected to backend

---

## ⚠️ **Troubleshooting**

### Backend won't start
```powershell
# Check if port 5000 is in use
netstat -ano | findstr :5000

# Kill the process
taskkill /F /PID <PID_NUMBER>

# Try again
npm run dev
```

### Admin dashboard can't connect
- ✅ Check backend is running on port 5000
- ✅ Verify `.env` file: `VITE_API_URL=http://localhost:5000/api`
- ✅ Check browser console for errors

### Products not showing in mobile app
- ✅ Verify backend is running
- ✅ Check mobile app API URL: `http://10.0.2.2:5000/api` (Android emulator)
- ✅ Refresh the mobile app
- ✅ Check if products exist in MongoDB

---

## 📊 **Quick Test**

1. **Add a product in admin dashboard**
2. **Check mobile app** - Should appear immediately!
3. **Mark as Featured** - Shows at top of mobile home screen

---

## 🎉 **You're All Set!**

Both services running = Admin can add products → Mobile app shows them!


