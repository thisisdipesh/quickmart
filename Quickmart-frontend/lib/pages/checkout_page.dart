import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/summary_row.dart';
import '../widgets/payment_option_tile.dart';
import '../widgets/primary_button.dart';
import '../services/user_service.dart';
import 'login_page.dart';
import 'select_location_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'Khalti';
  double? _selectedLat;
  double? _selectedLng;
  DateTime? _selectedDeliveryDate;
  TimeOfDay? _selectedDeliveryTime;

  Future<void> _selectDeliveryLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectLocationPage(),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        // Handle both formats: 'latitude'/'longitude' or 'lat'/'lng'
        _selectedLat = result['latitude'] ?? result['lat'];
        _selectedLng = result['longitude'] ?? result['lng'];
      });
    }
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(const Duration(days: 30));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6F52ED),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDeliveryDate = picked;
      });
    }
  }

  Future<void> _selectDeliveryTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedDeliveryTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6F52ED),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDeliveryTime = picked;
      });
    }
  }

  String _formatDeliveryDateTime() {
    if (_selectedDeliveryDate == null || _selectedDeliveryTime == null) {
      return 'Select delivery date & time';
    }

    final dateStr = '${_selectedDeliveryDate!.day}/${_selectedDeliveryDate!.month}/${_selectedDeliveryDate!.year}';
    final timeStr = _selectedDeliveryTime!.format(context);
    return '$dateStr, $timeStr';
  }

  @override
  void initState() {
    super.initState();
    // Check if user is logged in when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await UserService.ensureInitialized();
      if (!UserService.isLoggedIn()) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      }
    });
  }

  Future<void> _handleCheckOut() async {
    // Ensure initialization and double check if user is logged in
    await UserService.ensureInitialized();
    if (!UserService.isLoggedIn()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
      return;
    }

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
        InkWell(
          onTap: _selectDeliveryLocation,
          borderRadius: BorderRadius.circular(16),
          child: Container(
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
                        _selectedLat != null && _selectedLng != null
                            ? 'Location Selected'
                            : 'Tap to select delivery location',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_selectedLat != null && _selectedLng != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lat: ${_selectedLat!.toStringAsFixed(6)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9E9E9E),
                              ),
                            ),
                            Text(
                              'Lng: ${_selectedLng!.toStringAsFixed(6)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Select your delivery location on map',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Delivery Date & Time Row
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
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6F52ED).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_today,
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
                          _formatDeliveryDateTime(),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedDeliveryDate != null && _selectedDeliveryTime != null
                              ? 'Delivery scheduled'
                              : 'Select delivery date & time',
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDeliveryDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedDeliveryDate != null
                              ? const Color(0xFF6F52ED).withOpacity(0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedDeliveryDate != null
                                ? const Color(0xFF6F52ED)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: _selectedDeliveryDate != null
                                  ? const Color(0xFF6F52ED)
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDeliveryDate != null
                                  ? '${_selectedDeliveryDate!.day}/${_selectedDeliveryDate!.month}/${_selectedDeliveryDate!.year}'
                                  : 'Select Date',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _selectedDeliveryDate != null
                                    ? const Color(0xFF6F52ED)
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _selectDeliveryTime,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedDeliveryTime != null
                              ? const Color(0xFF6F52ED).withOpacity(0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedDeliveryTime != null
                                ? const Color(0xFF6F52ED)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: _selectedDeliveryTime != null
                                  ? const Color(0xFF6F52ED)
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDeliveryTime != null
                                  ? _selectedDeliveryTime!.format(context)
                                  : 'Select Time',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _selectedDeliveryTime != null
                                    ? const Color(0xFF6F52ED)
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Quick Time Slots
        if (_selectedDeliveryDate != null && _selectedDeliveryTime == null)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Time Slot',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildTimeSlot('09:00', 'Morning'),
                    _buildTimeSlot('12:00', 'Noon'),
                    _buildTimeSlot('15:00', 'Afternoon'),
                    _buildTimeSlot('18:00', 'Evening'),
                    _buildTimeSlot('21:00', 'Night'),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTimeSlot(String time, String label) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final timeOfDay = TimeOfDay(hour: hour, minute: minute);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDeliveryTime = timeOfDay;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _selectedDeliveryTime == timeOfDay
              ? const Color(0xFF6F52ED).withOpacity(0.1)
              : Colors.grey.shade100,
          border: Border.all(
            color: _selectedDeliveryTime == timeOfDay
                ? const Color(0xFF6F52ED)
                : Colors.grey.shade300,
            width: _selectedDeliveryTime == timeOfDay ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _selectedDeliveryTime == timeOfDay
                    ? const Color(0xFF6F52ED)
                    : Colors.black87,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: _selectedDeliveryTime == timeOfDay
                    ? const Color(0xFF6F52ED)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
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
