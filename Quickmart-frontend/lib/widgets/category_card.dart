import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final IconData iconData;
  final Color? backgroundColor;
  final String? iconUrl;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.iconData,
    required this.label,
    this.iconPath = '',
    this.backgroundColor,
    this.iconUrl,
    this.onTap,
  });

  String _getImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'http://10.0.2.2:5000$url';
  }

  @override
  Widget build(BuildContext context) {
    final hasImageUrl = iconUrl != null && iconUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: hasImageUrl
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _getImageUrl(iconUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        iconData,
                        size: 40,
                        color: const Color(0xFF7C3AED),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: const Color(0xFF7C3AED),
                        ),
                      );
                    },
                  ),
                )
              : Icon(
                  iconData,
                  size: 40,
                  color: const Color(0xFF7C3AED),
                ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 90,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    );
  }
}

