import '../models/category_model.dart';

class CategoryController {
  // Placeholder list for now (will be replaced with MongoDB calls)
  static List<CategoryModel> _categories = [
    CategoryModel(
      id: '1',
      name: 'Electronics',
      iconUrl: '',
    ),
    CategoryModel(
      id: '2',
      name: 'Clothing',
      iconUrl: '',
    ),
    CategoryModel(
      id: '3',
      name: 'Food & Beverages',
      iconUrl: '',
    ),
    CategoryModel(
      id: '4',
      name: 'Home & Garden',
      iconUrl: '',
    ),
  ];

  // Add a new category
  Future<void> addCategory(CategoryModel category) async {
    // TODO: Implement MongoDB API call
    // Example: await ApiService.post('/categories', category.toJson());

    // Placeholder: Add to local list
    _categories.add(category);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Get all categories
  Future<List<CategoryModel>> getCategories() async {
    // TODO: Implement MongoDB API call
    // Example: final response = await ApiService.get('/categories');
    // return (response as List).map((json) => CategoryModel.fromJson(json)).toList();

    // Placeholder: Return local list
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_categories);
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    // TODO: Implement MongoDB API call
    // Example: await ApiService.delete('/categories/$categoryId');

    // Placeholder: Remove from local list
    _categories.removeWhere((category) => category.id == categoryId);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

