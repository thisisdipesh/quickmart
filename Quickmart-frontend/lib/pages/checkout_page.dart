import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/summary_row.dart';
import '../widgets/payment_option_tile.dart';
import '../widgets/primary_button.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'Khalti';

  void _handleCheckOut() {
    // Handle checkout logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order placed successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF6F52ED),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAddPaymentMethod() {
    // Handle add new payment method
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Add new payment method',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF6F52ED),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
        ),
        title: Text(
          'Check Out',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Information Section
                    _buildDeliveryInformationSection(),

                    const SizedBox(height: 24),

                    // Order Summary Section
                    _buildOrderSummarySection(),

                    const SizedBox(height: 24),

                    // Payment Method Section
                    _buildPaymentMethodSection(),
                  ],
                ),
              ),
            ),

            // Bottom Checkout Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  text: 'Check Out',
                  onPressed: _handleCheckOut,
                  height: 55,
                  borderRadius: 30,
                  backgroundColor: const Color(0xFF6F52ED),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Row
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF6F52ED).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFF6F52ED),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'N.K.Singh Marg, Kathmandu 44600',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kathmandu, Nepal',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Delivery Time Row
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF6F52ED).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Color(0xFF6F52ED),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '6:00 pm, Wednesday 20',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Items
          const SummaryRow(label: 'Items', value: '3', isTotal: false),
          const SizedBox(height: 12),

          // Subtotal
          const SummaryRow(label: 'Subtotal', value: 'Rs 5030', isTotal: false),
          const SizedBox(height: 12),

          // Discount
          const SummaryRow(label: 'Discount', value: 'Rs 130', isTotal: false),
          const SizedBox(height: 12),

          // Delivery Charges
          const SummaryRow(
            label: 'Delivery Charges',
            value: 'Rs 89',
            isTotal: false,
          ),
          const SizedBox(height: 16),

          // Divider
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          const SizedBox(height: 16),

          // Total
          const SummaryRow(label: 'Total', value: 'Rs 4989', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose payment method',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Khalti Payment Option
        PaymentOptionTile(
          paymentName: 'Khalti',
          icon: Icons.account_balance_wallet,
          isSelected: _selectedPaymentMethod == 'Khalti',
          onTap: () {
            setState(() {
              _selectedPaymentMethod = 'Khalti';
            });
          },
        ),

        // Cash Payment Option
        PaymentOptionTile(
          paymentName: 'Cash',
          icon: Icons.money,
          isSelected: _selectedPaymentMethod == 'Cash',
          onTap: () {
            setState(() {
              _selectedPaymentMethod = 'Cash';
            });
          },
        ),

        // Add New Payment Method
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add,
                color: const Color(0xFF6F52ED),
                size: 24,
              ),
            ),
            title: Text(
              'Add new payment method',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6F52ED),
              ),
            ),
            trailing: Icon(
              Icons.add,
              color: const Color(0xFF6F52ED),
            ),
            onTap: _handleAddPaymentMethod,
          ),
        ),
      ],
    );
  }
}
