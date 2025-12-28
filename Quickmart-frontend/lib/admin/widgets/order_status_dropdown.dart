import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStatusDropdown extends StatelessWidget {
  final String currentStatus;
  final Function(String) onChanged;

  const OrderStatusDropdown({
    super.key,
    required this.currentStatus,
    required this.onChanged,
  });

  final List<String> statuses = const [
    'Order Placed',
    'Gathering Items',
    'Picked Up',
    'On The Way',
    'Delivered',
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Placed':
        return Colors.blue;
      case 'Gathering Items':
        return Colors.orange;
      case 'Picked Up':
        return Colors.purple;
      case 'On The Way':
        return Colors.indigo;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(currentStatus).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getStatusColor(currentStatus).withOpacity(0.3),
        ),
      ),
      child: DropdownButton<String>(
        value: currentStatus,
        isExpanded: false,
        underline: const SizedBox.shrink(),
        icon: Icon(Icons.arrow_drop_down, color: _getStatusColor(currentStatus)),
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(currentStatus),
        ),
        items: statuses.map((String status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}

