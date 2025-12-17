import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final Function(int)? onQuantityChanged;
  final int minQuantity;
  final int maxQuantity;

  const QuantitySelector({
    super.key,
    this.initialQuantity = 1,
    this.onQuantityChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  void _decrement() {
    if (_quantity > widget.minQuantity) {
      setState(() {
        _quantity--;
      });
      widget.onQuantityChanged?.call(_quantity);
    }
  }

  void _increment() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
      });
      widget.onQuantityChanged?.call(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrement button - Circular purple
        GestureDetector(
          onTap: _decrement,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _quantity > widget.minQuantity
                  ? const Color(0xFF6F52ED)
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove,
              color: _quantity > widget.minQuantity
                  ? Colors.white
                  : Colors.grey.shade600,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Quantity text
        Text(
          _quantity.toString(),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 12),
        // Increment button - Circular purple
        GestureDetector(
          onTap: _increment,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _quantity < widget.maxQuantity
                  ? const Color(0xFF6F52ED)
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: _quantity < widget.maxQuantity
                  ? Colors.white
                  : Colors.grey.shade600,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
