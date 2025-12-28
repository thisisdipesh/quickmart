import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { productsAPI, categoriesAPI } from '../services/api';

const Products = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      setLoading(true);
      const response = await productsAPI.getAll({ limit: 100 });
      const productsData = response.data.data.products || [];
      console.log('Fetched products:', productsData);
      productsData.forEach((prod) => {
        console.log(`Product: ${prod.name}, imageUrl: ${prod.imageUrl}`);
      });
      setProducts(productsData);
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to fetch products');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this product?')) {
      return;
    }

    try {
      await productsAPI.delete(id);
      setProducts(products.filter((p) => p._id !== id));
    } catch (err) {
      alert(err.response?.data?.message || 'Failed to delete product');
    }
  };

  const getImageUrl = (imageUrl) => {
    console.log('Product imageUrl received:', imageUrl);
    if (!imageUrl || imageUrl.trim() === '' || imageUrl === 'undefined') {
      console.log('No imageUrl, returning placeholder');
      return 'https://via.placeholder.com/100';
    }
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      console.log('Full URL detected, returning as-is:', imageUrl);
      return imageUrl;
    }
    // Ensure imageUrl starts with /uploads
    const cleanUrl = imageUrl.startsWith('/') ? imageUrl : `/${imageUrl}`;
    const fullUrl = `http://localhost:5000${cleanUrl}`;
    console.log('Constructed URL:', fullUrl);
    return fullUrl;
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-500">Loading products...</div>
      </div>
    );
  }

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Products</h1>
        <Link
          to="/products/add"
          className="bg-primary-600 text-white px-4 py-2 rounded-lg hover:bg-primary-700 transition-colors"
        >
          + Add Product
        </Link>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded mb-4">
          {error}
        </div>
      )}

      <div className="bg-white rounded-lg shadow-md overflow-hidden border border-gray-200">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Image
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Name
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Category
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Price
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Stock
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Featured
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {products.length === 0 ? (
                <tr>
                  <td colSpan="7" className="px-6 py-4 text-center text-gray-500">
                    No products found
                  </td>
                </tr>
              ) : (
                products.map((product) => {
                  // Debug: Log product data
                  console.log('Product:', product.name, 'imageUrl:', product.imageUrl);
                  const hasImage = product.imageUrl && product.imageUrl.trim() !== '' && product.imageUrl !== 'undefined';
                  const imageUrl = getImageUrl(product.imageUrl);
                  console.log('hasImage:', hasImage, 'imageUrl:', imageUrl);
                  return (
                    <tr key={product._id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="relative h-12 w-12">
                          {hasImage ? (
                            <img
                              src={imageUrl}
                              alt={product.name}
                              className="h-12 w-12 object-cover rounded border border-gray-200"
                              onError={(e) => {
                                console.error('Failed to load product image. URL:', imageUrl, 'Original:', product.imageUrl);
                                e.target.onerror = null;
                                e.target.style.display = 'none';
                                const placeholder = e.target.parentElement.querySelector('.placeholder-image');
                                if (placeholder) placeholder.style.display = 'flex';
                              }}
                              onLoad={() => {
                                console.log('Product image loaded successfully:', imageUrl);
                              }}
                            />
                          ) : null}
                          <div 
                            className="h-12 w-12 bg-gray-100 rounded border border-gray-200 flex items-center justify-center placeholder-image"
                            style={{ display: hasImage ? 'none' : 'flex', position: hasImage ? 'absolute' : 'relative', top: 0, left: 0 }}
                          >
                            <span className="text-xs text-gray-400">No Image</span>
                          </div>
                        </div>
                      </td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-medium text-gray-900">{product.name}</div>
                      <div className="text-sm text-gray-500 truncate max-w-xs">
                        {product.description}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {product.category?.name || 'N/A'}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      ${product.price}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {product.stock}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      {product.isFeatured ? (
                        <span className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                          Yes
                        </span>
                      ) : (
                        <span className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                          No
                        </span>
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                      <Link
                        to={`/products/edit/${product._id}`}
                        className="text-primary-600 hover:text-primary-900"
                      >
                        Edit
                      </Link>
                      <button
                        onClick={() => handleDelete(product._id)}
                        className="text-red-600 hover:text-red-900"
                      >
                        Delete
                      </button>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default Products;



