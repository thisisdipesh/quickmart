import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import '../models/order_model.dart';
import '../services/order_service.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;

  const OrderTrackingPage({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final MapController _mapController = MapController();
  Order? _order;
  bool _isLoading = true;
  String? _error;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrder() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await OrderService.getOrderById(widget.orderId);
      
      if (response['success'] == true && response['data'] != null) {
        final order = Order.fromJson(response['data']);
        
        setState(() {
          _order = order;
          _isLoading = false;
        });

        // Center map on delivery location
        if (order.lat != 0.0 && order.lng != 0.0) {
          _mapController.move(
            LatLng(order.lat, order.lng),
            15.0,
          );
        }
      } else {
        setState(() {
          _error = response['message'] ?? 'Failed to fetch order';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _startPolling() {
    // Poll every 10 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _fetchOrder();
      }
    });
  }

  List<Map<String, dynamic>> _getStatusSteps() {
    return [
      {'key': 'placed', 'label': 'Order placed'},
      {'key': 'gathering', 'label': 'Gathering items'},
      {'key': 'picked', 'label': 'Picked up'},
      {'key': 'on_the_way', 'label': 'On the way'},
      {'key': 'delivered', 'label': 'Delivered'},
    ];
  }

  String _getEstimatedDeliveryTime() {
    if (_order?.deliveryTime != null && _order!.deliveryTime!.isNotEmpty) {
      return _order!.deliveryTime!;
    }
    
    // Default: 30 minutes from order time
    if (_order != null) {
      final estimatedTime = _order!.createdAt.add(const Duration(minutes: 30));
      final hour = estimatedTime.hour;
      final minute = estimatedTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    }
    return '12:30 PM';
  }

  String _getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return 'https://via.placeholder.com/60x60?text=Product';
    }
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }
    // Assuming backend serves images from /uploads
    return '${ApiService.baseUrl.replaceAll('/api', '')}$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: _isLoading && _order == null
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _order == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _fetchOrder,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _order == null
                    ? const Center(child: Text('Order not found'))
                    : Column(
                        children: [
                          // Header Section
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.grey.shade800,
                                    size: 24,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Order #${_order!.id.substring(_order!.id.length - 8)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 48),
                              ],
                            ),
                          ),

                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Sub-heading
                                  Center(
                                    child: Text(
                                      _order!.status == 'delivered'
                                          ? 'Your order has been delivered'
                                          : 'Your order is on the way',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Map Section (45% height)
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.45,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: FlutterMap(
                                            mapController: _mapController,
                                            options: MapOptions(
                                              center: LatLng(_order!.lat, _order!.lng),
                                              zoom: 15.0,
                                              minZoom: 5.0,
                                              maxZoom: 18.0,
                                            ),
                                            children: [
                                              // OpenStreetMap tile layer
                                              TileLayer(
                                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                userAgentPackageName: 'com.quickmart.app',
                                                maxZoom: 19,
                                              ),
                                              // Marker layer - RED marker at delivery location
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    point: LatLng(_order!.lat, _order!.lng),
                                                    width: 50,
                                                    height: 50,
                                                    child: Icon(
                                                      Icons.location_on,
                                                      color: Colors.red,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Zoom controls
                                        Positioned(
                                          right: 16,
                                          bottom: 16,
                                          child: Column(
                                            children: [
                                              FloatingActionButton.small(
                                                heroTag: 'zoom_in',
                                                onPressed: () {
                                                  _mapController.move(
                                                    _mapController.camera.center,
                                                    _mapController.camera.zoom + 1,
                                                  );
                                                },
                                                backgroundColor: Colors.white,
                                                child: const Icon(Icons.add, color: Colors.black87),
                                              ),
                                              const SizedBox(height: 8),
                                              FloatingActionButton.small(
                                                heroTag: 'zoom_out',
                                                onPressed: () {
                                                  _mapController.move(
                                                    _mapController.camera.center,
                                                    _mapController.camera.zoom - 1,
                                                  );
                                                },
                                                backgroundColor: Colors.white,
                                                child: const Icon(Icons.remove, color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Estimated delivery time + Progress Bar
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Estimated delivery time ${_getEstimatedDeliveryTime()}',
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
                                          value: _order!.progress / 100,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            _order!.status == 'delivered'
                                                ? Colors.green
                                                : const Color(0xFF6C63FF),
                                          ),
                                          minHeight: 8,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  // Driver Information
                                  if (_order!.driverName != null && _order!.driverName!.isNotEmpty)
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
                                              color: const Color(0xFF6C63FF).withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              color: Color(0xFF6C63FF),
                                              size: 24,
                                            ),
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
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _order!.driverName!,
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

                                  if (_order!.driverName != null && _order!.driverName!.isNotEmpty)
                                    const SizedBox(height: 24),

                                  // Item Ordered Section
                                  if (_order!.items.isNotEmpty)
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
                                            'Item Ordered',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          ...(_order!.items.map((item) => Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(
                                                        _getImageUrl(item.imageUrl),
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Container(
                                                            width: 60,
                                                            height: 60,
                                                            color: Colors.grey.shade200,
                                                            child: Icon(
                                                              Icons.image,
                                                              size: 30,
                                                              color: Colors.grey.shade400,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            item.name,
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            'Qty: ${item.quantity} × Rs ${item.price.toStringAsFixed(2)}',
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              color: Colors.grey.shade600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))),
                                        ],
                                      ),
                                    ),

                                  if (_order!.items.isNotEmpty) const SizedBox(height: 24),

                                  // Order Status Timeline
                                  Container(
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
                                        ..._buildStatusTimeline(),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 100), // Space for bottom button
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
                              child: CustomButton(
                                text: 'Look For More Products',
                                onPressed: () {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                },
                                height: 55,
                                borderRadius: 30,
                                backgroundColor: const Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }

  List<Widget> _buildStatusTimeline() {
    final steps = _getStatusSteps();
    final currentStatus = _order!.status;

    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;
      final stepLabel = step['label'] as String;

      // Determine status
      final statusIndex = steps.indexWhere((s) => s['key'] == currentStatus);
      final isCompleted = index < statusIndex;
      final isCurrent = index == statusIndex;
      final isPending = index > statusIndex;

      Color dotColor;
      if (isCompleted) {
        dotColor = Colors.green;
      } else if (isCurrent) {
        dotColor = Colors.purple;
      } else {
        dotColor = Colors.grey;
      }

      final isLast = index == steps.length - 1;

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
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
              ),
              if (!isLast)
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
                stepLabel,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: isCompleted || isCurrent ? FontWeight.w600 : FontWeight.w400,
                  color: isPending ? Colors.grey.shade600 : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
