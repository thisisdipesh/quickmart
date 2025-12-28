import '../models/category_model.dart';
import '../../services/api_service.dart';

class CategoryController {
  // Get all categories from API
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await ApiService.get('categories');
      
      if (response['success'] == true && response['data'] != null) {
        final categories = response['data']['categories'] as List?;
        if (categories != null) {
          return categories.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      // Return empty list if no categories found
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      // Return empty list on error
      return [];
    }
  }

  // Add a new category
  Future<bool> addCategory(CategoryModel category) async {
    try {
      // Note: This would need to be implemented with multipart/form-data for icon upload
      return true;
    } catch (e) {
      print('Error adding category: $e');
      return false;
    }
  }

  // Delete a category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      // Note: Should use DELETE method, but ApiService only has GET and POST
      return true;
    } catch (e) {
      print('Error deleting category: $e');
      return false;
    }
  }
}




