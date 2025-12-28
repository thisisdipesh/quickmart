import { useState, useEffect } from 'react';
import { categoriesAPI } from '../services/api';

const Categories = () => {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [formData, setFormData] = useState({ name: '', icon: null });

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    try {
      setLoading(true);
      const response = await categoriesAPI.getAll();
      const categoriesData = response.data.data.categories || [];
      console.log('Fetched categories:', categoriesData);
      categoriesData.forEach((cat) => {
        console.log(`Category: ${cat.name}, iconUrl: ${cat.iconUrl}`);
      });
      setCategories(categoriesData);
    } catch (error) {
      console.error('Error fetching categories:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const data = new FormData();
      data.append('name', formData.name);
      if (formData.icon) {
        data.append('icon', formData.icon);
      }

      await categoriesAPI.create(data);
      setShowAddModal(false);
      setFormData({ name: '', icon: null });
      fetchCategories();
    } catch (error) {
      alert(error.response?.data?.message || 'Failed to create category');
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this category?')) {
      return;
    }

    try {
      await categoriesAPI.delete(id);
      setCategories(categories.filter((c) => c._id !== id));
    } catch (error) {
      alert(error.response?.data?.message || 'Failed to delete category');
    }
  };

  const getIconUrl = (iconUrl) => {
    console.log('Category iconUrl received:', iconUrl);
    if (!iconUrl || iconUrl.trim() === '' || iconUrl === 'undefined') {
      console.log('No iconUrl, returning placeholder');
      return 'https://via.placeholder.com/64';
    }
    if (iconUrl.startsWith('http://') || iconUrl.startsWith('https://')) {
      console.log('Full URL detected, returning as-is:', iconUrl);
      return iconUrl;
    }
    // Ensure iconUrl starts with /uploads
    const cleanUrl = iconUrl.startsWith('/') ? iconUrl : `/${iconUrl}`;
    const fullUrl = `http://localhost:5000${cleanUrl}`;
    console.log('Constructed URL:', fullUrl);
    return fullUrl;
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-500">Loading categories...</div>
      </div>
    );
  }

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Categories</h1>
        <button
          onClick={() => setShowAddModal(true)}
          className="bg-primary-600 text-white px-4 py-2 rounded-lg hover:bg-primary-700 transition-colors"
        >
          + Add Category
        </button>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {categories.map((category) => {
          // Debug: Log category data
          console.log('Category:', category.name, 'iconUrl:', category.iconUrl);
          const hasIcon = category.iconUrl && category.iconUrl.trim() !== '' && category.iconUrl !== 'undefined';
          const iconUrl = getIconUrl(category.iconUrl);
          console.log('hasIcon:', hasIcon, 'iconUrl:', iconUrl);
          
          return (
            <div
              key={category._id}
              className="bg-white rounded-lg shadow-md p-6 border border-gray-200 hover:shadow-lg transition-shadow"
            >
              <div className="flex flex-col items-center text-center">
                <div className="relative w-16 h-16 mb-4">
                  {hasIcon ? (
                    <img
                      src={iconUrl}
                      alt={category.name}
                      className="w-16 h-16 object-cover rounded border border-gray-200"
                      onError={(e) => {
                        console.error('Failed to load category icon. URL:', iconUrl, 'Original:', category.iconUrl);
                        e.target.onerror = null;
                        e.target.style.display = 'none';
                        const placeholder = e.target.parentElement.querySelector('.placeholder-icon');
                        if (placeholder) placeholder.style.display = 'flex';
                      }}
                      onLoad={() => {
                        console.log('Category icon loaded successfully:', iconUrl);
                      }}
                    />
                  ) : null}
                  <div 
                    className="w-16 h-16 bg-gray-100 rounded border border-gray-200 flex items-center justify-center placeholder-icon"
                    style={{ display: hasIcon ? 'none' : 'flex', position: hasIcon ? 'absolute' : 'relative', top: 0, left: 0 }}
                  >
                    <span className="text-xs text-gray-400">No Icon</span>
                  </div>
                </div>
                <h3 className="text-lg font-semibold text-gray-800 mb-2">
                  {category.name}
                </h3>
              <button
                onClick={() => handleDelete(category._id)}
                className="text-red-600 hover:text-red-800 text-sm font-medium"
              >
                Delete
              </button>
            </div>
          </div>
          );
        })}
      </div>

      {showAddModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
            <h2 className="text-xl font-bold text-gray-800 mb-4">Add New Category</h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Category Name *
                </label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Category Icon
                </label>
                <input
                  type="file"
                  accept="image/*"
                  onChange={(e) => setFormData({ ...formData, icon: e.target.files[0] })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div className="flex space-x-4">
                <button
                  type="submit"
                  className="flex-1 bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700"
                >
                  Create
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setShowAddModal(false);
                    setFormData({ name: '', icon: null });
                  }}
                  className="flex-1 bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Categories;



