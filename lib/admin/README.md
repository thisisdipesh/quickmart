# Quick Mart Admin Panel

Complete Admin Panel UI for Quick Mart Flutter Web application.

## 📁 Structure

```
/lib/admin
    /pages
        - dashboard_page.dart
        - add_product_page.dart
        - product_list_page.dart
        - categories_page.dart
    /widgets
        - admin_sidebar.dart
        - admin_textfield.dart
        - admin_button.dart
    /models
        - product_model.dart
        - category_model.dart
    /controllers
        - product_controller.dart
        - category_controller.dart
    - admin_main.dart (Main entry point)
```

## 🚀 Usage

To access the admin panel, navigate to `AdminMain`:

```dart
import 'package:quick_mart/admin/admin_main.dart';

// In your navigation
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AdminMain()),
);
```

## ✨ Features

- **Dashboard**: Overview with statistics cards
- **Add Product**: Full form with image upload
- **Product List**: DataTable view with edit/delete actions
- **Categories**: Add and manage product categories

## 🎨 Design

- Clean white dashboard theme
- GoogleFonts.poppins typography
- Responsive web layout
- Fixed sidebar navigation
- Material Design 3

## 📝 Notes

- Controllers are prepared for MongoDB backend integration
- Models include `toJson()` and `fromJson()` methods
- Image uploads currently use local file paths (ready for server upload)
- All placeholder data will be replaced with actual API calls


