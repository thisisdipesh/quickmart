import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_status_dropdown.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderController _orderController = OrderController();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  Map<String, String> _pendingStatusUpdates = {};

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final orders = await _orderController.getAllOrders();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    // Store pending update
    setState(() {
      _pendingStatusUpdates[orderId] = newStatus;
    });

    final success = await _orderController.updateOrderStatus(orderId, newStatus);

    setState(() {
      _pendingStatusUpdates.remove(orderId);
    });

    if (success) {
      _loadOrders(); // Reload orders
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update order status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getOrderId(String? id) {
    if (id == null) return 'N/A';
    return id.length > 8 ? id.substring(id.length - 8) : id;
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
                'Orders',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadOrders,
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Orders Table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No orders found',
                              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
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
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                              columns: [
                                DataColumn(
                                  label: Text('Order ID', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                ),
                                DataColumn(
                                  label: Text('User', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                ),
                                DataColumn(
                                  label: Text('Total Price', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                ),
                                DataColumn(
                                  label: Text('Current Status', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                ),
                                DataColumn(
                                  label: Text('Change Status', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                ),
                                DataColumn(
                                  label: Text('Actions', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                ),
                              ],
                              rows: _orders.map((order) {
                                final orderId = order['_id'] as String? ?? '';
                                final currentStatus = order['orderStatus'] as String? ?? 'Order Placed';
                                final pendingStatus = _pendingStatusUpdates[orderId];
                                final displayStatus = pendingStatus ?? currentStatus;
                                final isUpdating = _pendingStatusUpdates.containsKey(orderId);

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text('#${_getOrderId(orderId)}', style: GoogleFonts.poppins()),
                                    ),
                                    DataCell(
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order['user']?['name'] ?? 'N/A',
                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            order['user']?['email'] ?? '',
                                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '\$${(order['total'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(currentStatus).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          currentStatus,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: _getStatusColor(currentStatus),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      isUpdating
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : OrderStatusDropdown(
                                              currentStatus: displayStatus,
                                              onChanged: (newStatus) {
                                                _updateOrderStatus(orderId, newStatus);
                                              },
                                            ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20),
                                        color: Colors.red,
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Delete Order', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                              content: Text('Are you sure you want to delete this order?', style: GoogleFonts.poppins()),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: Text('Cancel', style: GoogleFonts.poppins()),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                                  child: Text('Delete', style: GoogleFonts.poppins()),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            final success = await _orderController.deleteOrder(orderId);
                                            if (success) {
                                              _loadOrders();
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Order deleted successfully'),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

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
}

