class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String? driverName;
  final double lat;
  final double lng;
  final DateTime createdAt;
  final String? deliveryTime;
  final int progress;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.driverName,
    required this.lat,
    required this.lng,
    required this.createdAt,
    this.deliveryTime,
    this.progress = 20,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final orderData = json['order'] ?? json;
    
    // Extract location
    final location = orderData['location'] ?? {};
    final lat = location['lat']?.toDouble() ?? 0.0;
    final lng = location['lng']?.toDouble() ?? 0.0;

    // Extract items
    final itemsList = orderData['items'] as List<dynamic>? ?? [];
    final items = itemsList.map((item) => OrderItem.fromJson(item)).toList();

    // Extract status (support both 'status' and 'orderStatus')
    final status = orderData['status'] ?? orderData['orderStatus'] ?? 'placed';

    // Extract dates
    DateTime createdAt;
    if (orderData['createdAt'] != null) {
      if (orderData['createdAt'] is String) {
        createdAt = DateTime.parse(orderData['createdAt']);
      } else {
        createdAt = DateTime.now();
      }
    } else {
      createdAt = DateTime.now();
    }

    return Order(
      id: orderData['_id'] ?? orderData['id'] ?? '',
      items: items,
      totalAmount: (orderData['total'] ?? orderData['totalAmount'] ?? 0.0).toDouble(),
      status: status,
      driverName: orderData['driverName'],
      lat: lat,
      lng: lng,
      createdAt: createdAt,
      deliveryTime: orderData['deliveryTime'],
      progress: orderData['progress'] ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'driverName': driverName,
      'lat': lat,
      'lng': lng,
      'createdAt': createdAt.toIso8601String(),
      'deliveryTime': deliveryTime,
      'progress': progress,
    };
  }
}

class OrderItem {
  final String? productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  OrderItem({
    this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Handle both product object and direct fields
    final product = json['product'];
    String itemName = json['name'] ?? '';
    String? imageUrl = json['image'] ?? json['imageUrl'];

    if (product != null && product is Map) {
      itemName = product['name'] ?? itemName;
      imageUrl = product['imageUrl'] ?? product['image'] ?? imageUrl;
    }

    return OrderItem(
      productId: json['productId'] ?? (product is Map ? product['_id'] : null),
      name: itemName,
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

