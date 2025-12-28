import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000/api';

// Create axios instance
const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add token to requests if available
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    // For FormData, remove Content-Type to let browser set it with boundary
    if (config.data instanceof FormData) {
      delete config.headers['Content-Type'];
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Handle response errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Unauthorized - clear token and redirect to login
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Auth API
export const authAPI = {
  login: (email, password) =>
    api.post('/auth/login', { email, password }),
  register: (userData) =>
    api.post('/auth/register', userData),
  getProfile: () =>
    api.get('/auth/profile'),
};

// Products API
export const productsAPI = {
  getAll: (params) =>
    api.get('/products', { params }),
  getById: (id) =>
    api.get(`/products/${id}`),
  create: (formData) => {
    return api.post('/products', formData);
  },
  update: (id, formData) =>
    api.put(`/products/${id}`, formData, {
      // Let axios set Content-Type automatically for FormData
    }),
  delete: (id) =>
    api.delete(`/products/${id}`),
};

// Categories API
export const categoriesAPI = {
  getAll: () =>
    api.get('/categories'),
  getById: (id) =>
    api.get(`/categories/${id}`),
  create: (formData) =>
    api.post('/categories', formData, {
      // Let axios set Content-Type automatically for FormData
    }),
  update: (id, formData) =>
    api.put(`/categories/${id}`, formData, {
      // Let axios set Content-Type automatically for FormData
    }),
  delete: (id) =>
    api.delete(`/categories/${id}`),
};

// Users API
export const usersAPI = {
  getAll: () =>
    api.get('/users'),
  getById: (id) =>
    api.get(`/users/${id}`),
  update: (id, userData) =>
    api.put(`/users/${id}`, userData),
  delete: (id) =>
    api.delete(`/users/${id}`),
};

// Orders API
export const ordersAPI = {
  getAll: () =>
    api.get('/orders'),
  getById: (id) =>
    api.get(`/orders/${id}`),
  updateStatus: (id, orderData) =>
    api.put(`/orders/${id}`, orderData),
  delete: (id) =>
    api.delete(`/orders/${id}`),
};

export default api;



