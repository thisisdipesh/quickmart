import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/order_status_tile.dart';
import '../services/order_service.dart';

class OrderTrackingPage extends StatefulWidget {
  final String? orderId;

  const OrderTrackingPage({
    super.key,
    this.orderId,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  Map<String, dynamic>? order;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      _fetchOrder();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchOrder() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await OrderService.getOrderById(widget.orderId!);
      if (response['success'] == true && response['data'] != null) {
        setState(() {
          order = response['data']['order'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load order';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading order: $e';
        isLoading = false;
      });
    }
  }

  int _getStatusIndex(String? status) {
    if (status == null) return 0;
    const statuses = [
      'Order Placed',
      'Gathering Items',
      'Picked Up',
      'On The Way',
      'Delivered',
    ];
    return statuses.indexOf(status);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          ),
          title: Text(
            'Order #${widget.orderId ?? 'Loading...'}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null || order == null) {
      final orderId = widget.orderId ?? '111';
      return _buildUI(context, orderId, null);
    }

    final orderData = order!;
    final orderId = orderData['_id']?.toString().substring(orderData['_id'].toString().length - 8) ?? '111';
    final currentStatus = orderData['orderStatus'] as String? ?? 'Order Placed';
    final currentStatusIndex = _getStatusIndex(currentStatus);
    final progress = (orderData['progress'] as num?)?.toDouble() ?? 0.5;
    final driverName = orderData['driverName'] as String? ?? 'Ram Khadka';
    final deliveryTime = orderData['deliveryTime'] as String? ?? '12:30 PM';
    final items = orderData['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] : null;

    return _buildUI(
      context,
      orderId,
      _OrderData(
        status: currentStatus,
        statusIndex: currentStatusIndex,
        progress: progress / 100, // Convert to 0-1 range
        driverName: driverName,
        deliveryTime: deliveryTime,
        itemName: firstItem?['product']?['name'] ?? firstItem?['name'] ?? 'Ground turmeric',
        itemImage: firstItem?['product']?['imageUrl'] ?? firstItem?['image'] ?? '',
      ),
    );
  }

  Widget _buildUI(BuildContext context, String orderId, _OrderData? data) {
    final orderData = data ?? _OrderData(
      status: 'Picked Up',
      statusIndex: 2,
      progress: 0.5,
      driverName: 'Ram Khadka',
      deliveryTime: '12:30 PM',
      itemName: 'Ground turmeric',
      itemImage: '',
    );

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
          'Order #$orderId',
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
                    // Header Text
                    Center(
                      child: Text(
                        'Your order is on the way',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Map Section
                    _buildMapSection(context),

                    const SizedBox(height: 24),

                    // Delivery Time + Progress Bar
                    _buildDeliveryProgressSection(orderData.deliveryTime, orderData.progress),

                    const SizedBox(height: 24),

                    // Driver Information
                    _buildDriverInfoSection(orderData.driverName),

                    const SizedBox(height: 24),

                    // Item Ordered Section
                    _buildItemOrderedSection(orderData.itemName, orderData.itemImage),

                    const SizedBox(height: 24),

                    // Order Status Section
                    _buildOrderStatusSection(orderData.statusIndex),
                  ],
                ),
              ),
            ),

            // Bottom Button
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
                child: CustomButton(
                  text: 'Look For More Products',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
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

  Widget _buildMapSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Map placeholder image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://maps.googleapis.com/maps/api/staticmap?center=27.7172,85.3240&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7C27.7172,85.3240',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('Map Preview', style: GoogleFonts.poppins(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Red location pin icon
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width * 0.4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.location_on, color: Colors.red, size: 32),
            ),
          ),

          // Zoom controls on right
          Positioned(
            right: 12,
            top: 12,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {},
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: () {},
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryProgressSection(String deliveryTime, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated delivery time $deliveryTime',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6F52ED)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfoSection(String driverName) {
    return Container(
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
            child: const Icon(Icons.person, color: Color(0xFF6F52ED), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver:',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  driverName,
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
    );
  }

  Widget _buildItemOrderedSection(String itemName, String itemImage) {
    return Container(
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade100,
              child: itemImage.isNotEmpty
                  ? Image.network(
                      itemImage.startsWith('http')
                          ? itemImage
                          : 'http://10.0.2.2:5000$itemImage',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, size: 30, color: Colors.grey.shade400);
                      },
                    )
                  : Icon(Icons.image, size: 30, color: Colors.grey.shade400),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              itemName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusSection(int currentStatusIndex) {
    final statuses = ['Order placed', 'Gathering items', 'Picked up', 'On the way'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            'Order Status',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isCompleted = index <= currentStatusIndex;
            final isLast = index == statuses.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 0),
              child: OrderStatusTile(
                title: status,
                isCompleted: isCompleted,
                isLast: isLast,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _OrderData {
  final String status;
  final int statusIndex;
  final double progress;
  final String driverName;
  final String deliveryTime;
  final String itemName;
  final String itemImage;

  _OrderData({
    required this.status,
    required this.statusIndex,
    required this.progress,
    required this.driverName,
    required this.deliveryTime,
    required this.itemName,
    required this.itemImage,
  });
}
