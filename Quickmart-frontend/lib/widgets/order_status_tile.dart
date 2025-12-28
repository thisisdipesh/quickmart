import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStatusTile extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isLast;

  const OrderStatusTile({
    super.key,
    required this.title,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey.shade400,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
            ),
            if (isLast)
              const SizedBox.shrink()
            else
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Title
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                color: isCompleted ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

