import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';
import '../controllers/product_controller.dart';
import '../controllers/category_controller.dart';
import '../models/category_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final products = await ProductController().getProducts();
    final categories = await CategoryController().getCategories();

    setState(() {
      _products = products;
      _categories = categories;
      _isLoading = false;
    });
  }

  String _getCategoryName(String categoryId) {
    try {
      return _categories.firstWhere((c) => c.id == categoryId).name;
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget _buildProductImage(String imageUrl) {
    // Check if it's a file path (local file)
    if (imageUrl.startsWith('/') || imageUrl.contains('\\')) {
      try {
        final file = File(imageUrl);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported,
                color: Colors.grey[400],
              );
            },
          );
        }
      } catch (e) {
        // Fall through to placeholder
      }
    }

    // For URLs or invalid paths, show placeholder
    return Icon(
      Icons.image_not_supported,
      color: Colors.grey[400],
    );
  }

  Future<void> _deleteProduct(ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Product',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${product.name}"?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ProductController().deleteProduct(product.id);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Product List',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Products Table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              Colors.grey[50],
                            ),
                            columns: [
                              const DataColumn(
                                label: Text('Image'),
                              ),
                              DataColumn(
                                label: Text(
                                  'Product Name',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Category',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Price',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Stock',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Actions',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            rows: _products.map((product) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.grey[200],
                                      ),
                                      child: product.imageUrl.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: _buildProductImage(
                                                  product.imageUrl),
                                            )
                                          : Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey[400],
                                            ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.name,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      _getCategoryName(product.categoryId),
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.stock.toString(),
                                      style: GoogleFonts.poppins(
                                        color: product.stock < 10
                                            ? Colors.red
                                            : Colors.grey[900],
                                        fontWeight: product.stock < 10
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon:
                                              const Icon(Icons.edit, size: 20),
                                          color: const Color(0xFF7C3AED),
                                          onPressed: () {
                                            // TODO: Navigate to edit page
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Edit functionality coming soon'),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 20),
                                          color: Colors.red,
                                          onPressed: () =>
                                              _deleteProduct(product),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
