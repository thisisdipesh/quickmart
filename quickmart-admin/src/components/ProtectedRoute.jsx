import { Navigate } from 'react-router-dom';
import { useEffect, useState } from 'react';

const ProtectedRoute = ({ children }) => {
  const [isAuthorized, setIsAuthorized] = useState(false);
  const [isChecking, setIsChecking] = useState(true);

  useEffect(() => {
    const checkAuth = () => {
      const token = localStorage.getItem('token');
      const userStr = localStorage.getItem('user');
      
      if (!token || !userStr) {
        // Clear any invalid data
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        setIsAuthorized(false);
        setIsChecking(false);
        return;
      }

      try {
        const user = JSON.parse(userStr);
        
        // Only allow admin users
        if (user?.role === 'admin') {
          setIsAuthorized(true);
        } else {
          // Clear non-admin user data
          localStorage.removeItem('token');
          localStorage.removeItem('user');
          setIsAuthorized(false);
        }
      } catch (error) {
        // Invalid user data, clear it
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        setIsAuthorized(false);
      }
      
      setIsChecking(false);
    };

    checkAuth();
  }, []);

  // Show loading state while checking
  if (isChecking) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-600 border-r-transparent"></div>
          <p className="mt-4 text-gray-600">Verifying access...</p>
        </div>
      </div>
    );
  }

  // Redirect to login if not authorized
  if (!isAuthorized) {
    return <Navigate to="/login" replace />;
  }

  return children;
};

export default ProtectedRoute;


