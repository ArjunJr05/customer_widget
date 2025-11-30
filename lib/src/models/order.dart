/// Customer order model for SalesIQ widget
class CustomerOrder {
  final String id;
  final String customerName;
  final String customerEmail;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String orderDate;
  final String? trackingNumber;
  final String? shippingAddress;
  final String? deliveryDate;

  CustomerOrder({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.orderDate,
    this.trackingNumber,
    this.shippingAddress,
    this.deliveryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate,
      'trackingNumber': trackingNumber,
      'shippingAddress': shippingAddress,
      'deliveryDate': deliveryDate,
    };
  }

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    return CustomerOrder(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      orderDate: json['orderDate'] ?? '',
      trackingNumber: json['trackingNumber'],
      shippingAddress: json['shippingAddress'],
      deliveryDate: json['deliveryDate'],
    );
  }
}

/// Order item model
class OrderItem {
  final String productName;
  final double price;
  final int quantity;
  final String? sku;
  final String? image;

  OrderItem({
    required this.productName,
    required this.price,
    required this.quantity,
    this.sku,
    this.image,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'sku': sku,
      'image': image,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      sku: json['sku'],
      image: json['image'],
    );
  }
}
