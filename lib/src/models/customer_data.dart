import 'order.dart';
import 'support_issue.dart';

/// Complete customer data model for SalesIQ widget
class CustomerData {
  final String customerEmail;
  final String customerName;
  final List<CustomerOrder> orders;
  final List<SupportIssue> issues;
  final CustomerAnalytics analytics;
  final List<CustomerActivity> activities;

  CustomerData({
    required this.customerEmail,
    required this.customerName,
    required this.orders,
    required this.issues,
    required this.analytics,
    required this.activities,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerEmail': customerEmail,
      'customerName': customerName,
      'orders': orders.map((order) => order.toJson()).toList(),
      'issues': issues.map((issue) => issue.toJson()).toList(),
      'analytics': analytics.toJson(),
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      customerEmail: json['customerEmail'] ?? '',
      customerName: json['customerName'] ?? '',
      orders: (json['orders'] as List<dynamic>?)
          ?.map((order) => CustomerOrder.fromJson(order))
          .toList() ?? [],
      issues: (json['issues'] as List<dynamic>?)
          ?.map((issue) => SupportIssue.fromJson(issue))
          .toList() ?? [],
      analytics: CustomerAnalytics.fromJson(json['analytics'] ?? {}),
      activities: (json['activities'] as List<dynamic>?)
          ?.map((activity) => CustomerActivity.fromJson(activity))
          .toList() ?? [],
    );
  }
}

/// Customer analytics and insights
class CustomerAnalytics {
  final int totalOrders;
  final double totalSpent;
  final double avgOrderValue;
  final String loyaltyStatus;
  final String customerSince;
  final String favoriteCategory;

  CustomerAnalytics({
    required this.totalOrders,
    required this.totalSpent,
    required this.avgOrderValue,
    required this.loyaltyStatus,
    required this.customerSince,
    required this.favoriteCategory,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'avgOrderValue': avgOrderValue,
      'loyaltyStatus': loyaltyStatus,
      'customerSince': customerSince,
      'favoriteCategory': favoriteCategory,
    };
  }

  factory CustomerAnalytics.fromJson(Map<String, dynamic> json) {
    return CustomerAnalytics(
      totalOrders: json['totalOrders'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      avgOrderValue: (json['avgOrderValue'] ?? 0).toDouble(),
      loyaltyStatus: json['loyaltyStatus'] ?? 'New Customer',
      customerSince: json['customerSince'] ?? DateTime.now().toString().split(' ')[0],
      favoriteCategory: json['favoriteCategory'] ?? 'General',
    );
  }
}

/// Customer activity tracking
class CustomerActivity {
  final String id;
  final String date;
  final String action;
  final String details;
  final String platform;
  final String type;

  CustomerActivity({
    required this.id,
    required this.date,
    required this.action,
    required this.details,
    required this.platform,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'action': action,
      'details': details,
      'platform': platform,
      'type': type,
    };
  }

  factory CustomerActivity.fromJson(Map<String, dynamic> json) {
    return CustomerActivity(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      action: json['action'] ?? '',
      details: json['details'] ?? '',
      platform: json['platform'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
