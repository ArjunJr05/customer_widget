import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// Note: Replace with actual SalesIQ package when available
// import 'package:salesiq_mobilisten/salesiq_mobilisten.dart';

import 'config/salesiq_config.dart';
import 'models/customer_data.dart';
import 'models/order.dart';
import 'models/support_issue.dart';

/// Main service class for SalesIQ Customer Widget integration
class SalesIQCustomerService {
  static SalesIQCustomerService? _instance;
  static SalesIQConfig? _config;
  
  SalesIQCustomerService._internal();
  
  /// Get singleton instance
  static SalesIQCustomerService get instance {
    _instance ??= SalesIQCustomerService._internal();
    return _instance!;
  }

  /// Initialize the service with configuration
  static Future<void> initialize(SalesIQConfig config) async {
    _config = config;
    
    if (!config.isValid) {
      throw ArgumentError('Invalid SalesIQ configuration provided');
    }

    // Initialize SalesIQ SDK
    // TODO: Replace with actual SalesIQ initialization when package is available
    // await ZohoSalesIQ.initMobilisten(
    //   config.salesiqAppKey,
    //   config.salesiqAccessKey,
    // );
    await _initializeMockSalesIQ(config.salesiqAppKey, config.salesiqAccessKey);

    if (config.enableLogging) {
      log('SalesIQ Customer Widget initialized with webhook: ${config.webhookUrl}');
    }
  }

  /// Get current configuration
  static SalesIQConfig? get config => _config;

  /// Set customer information for SalesIQ
  Future<void> setCustomerInfo({
    required String email,
    required String name,
    String? phone,
    Map<String, String>? customFields,
  }) async {
    try {
      // Set visitor info in SalesIQ
      // TODO: Replace with actual SalesIQ call when package is available
      // await ZohoSalesIQ.setVisitorInfo(
      //   email,
      //   name: name,
      //   phone: phone,
      //   customFields: customFields,
      // );
      await _setMockVisitorInfo(email, name, phone, customFields);

      // Store customer info locally for webhook
      await _storeCustomerInfo(email, name, phone, customFields);

      if (_config?.enableLogging == true) {
        log('Customer info set for SalesIQ: $email');
      }
    } catch (e) {
      if (_config?.enableLogging == true) {
        log('Error setting customer info: $e');
      }
      rethrow;
    }
  }

  /// Track customer order
  Future<void> trackOrder(CustomerOrder order) async {
    try {
      // Store order data locally
      await _storeOrderData(order);

      // Track activity in SalesIQ
      await _trackActivity(
        'Order Placed',
        'Order ${order.id} placed for ₹${order.totalAmount}',
        'purchase',
      );

      if (_config?.enableLogging == true) {
        log('Order tracked: ${order.id}');
      }
    } catch (e) {
      if (_config?.enableLogging == true) {
        log('Error tracking order: $e');
      }
    }
  }

  /// Track support issue
  Future<void> trackIssue(SupportIssue issue) async {
    try {
      // Store issue data locally
      await _storeIssueData(issue);

      // Track activity in SalesIQ
      await _trackActivity(
        'Issue Reported',
        '${issue.issueType}: ${issue.description}',
        'support',
      );

      if (_config?.enableLogging == true) {
        log('Issue tracked: ${issue.id}');
      }
    } catch (e) {
      if (_config?.enableLogging == true) {
        log('Error tracking issue: $e');
      }
    }
  }

  /// Get customer data for webhook
  Future<CustomerData?> getCustomerData(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get customer info
      final customerName = prefs.getString('customer_name_$email') ?? 'Unknown Customer';
      
      // Get orders
      final ordersJson = prefs.getStringList('orders_$email') ?? [];
      final orders = ordersJson
          .map((orderStr) => CustomerOrder.fromJson(jsonDecode(orderStr)))
          .toList();

      // Get issues
      final issuesJson = prefs.getStringList('issues_$email') ?? [];
      final issues = issuesJson
          .map((issueStr) => SupportIssue.fromJson(jsonDecode(issueStr)))
          .toList();

      // Calculate analytics
      final analytics = _calculateAnalytics(orders);

      // Get activities
      final activitiesJson = prefs.getStringList('activities_$email') ?? [];
      final activities = activitiesJson
          .map((activityStr) => CustomerActivity.fromJson(jsonDecode(activityStr)))
          .toList();

      return CustomerData(
        customerEmail: email,
        customerName: customerName,
        orders: orders,
        issues: issues,
        analytics: analytics,
        activities: activities,
      );
    } catch (e) {
      if (_config?.enableLogging == true) {
        log('Error getting customer data: $e');
      }
      return null;
    }
  }

  /// Sync customer data with webhook server
  Future<void> syncWithWebhook(String email) async {
    if (_config == null) {
      throw StateError('SalesIQ Customer Service not initialized');
    }

    try {
      final customerData = await getCustomerData(email);
      if (customerData == null) return;

      final response = await http.post(
        Uri.parse('${_config!.customerDataEndpoint}/$email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(customerData.toJson()),
      );

      if (response.statusCode == 200) {
        if (_config?.enableLogging == true) {
          log('Customer data synced with webhook for: $email');
        }
      } else {
        throw Exception('Failed to sync with webhook: ${response.statusCode}');
      }
    } catch (e) {
      if (_config?.enableLogging == true) {
        log('Error syncing with webhook: $e');
      }
      rethrow;
    }
  }

  /// Show SalesIQ chat
  Future<void> showChat() async {
    try {
      // TODO: Replace with actual SalesIQ call when package is available
      // await ZohoSalesIQ.showChat();
      await _showMockChat();
    } catch (e) {
      if (_config?.enableLogging == true) {
        log('Error showing chat: $e');
      }
      rethrow;
    }
  }

  /// Hide SalesIQ chat
  Future<void> hideChat() async {
    try {
      // TODO: Replace with actual SalesIQ call when package is available
      // await ZohoSalesIQ.hideChat();
      await _hideMockChat();
    } catch (e) {
      if (_config?.enableLogging == true) {
        log('Error hiding chat: $e');
      }
    }
  }

  // Private helper methods

  Future<void> _storeCustomerInfo(
    String email,
    String name,
    String? phone,
    Map<String, String>? customFields,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('customer_name_$email', name);
    if (phone != null) {
      await prefs.setString('customer_phone_$email', phone);
    }
    if (customFields != null) {
      await prefs.setString('customer_fields_$email', jsonEncode(customFields));
    }
  }

  Future<void> _storeOrderData(CustomerOrder order) async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList('orders_${order.customerEmail}') ?? [];
    ordersJson.add(jsonEncode(order.toJson()));
    await prefs.setStringList('orders_${order.customerEmail}', ordersJson);
  }

  Future<void> _storeIssueData(SupportIssue issue) async {
    final prefs = await SharedPreferences.getInstance();
    // Assuming we can get customer email from context
    final customerEmail = await _getCurrentCustomerEmail();
    if (customerEmail != null) {
      final issuesJson = prefs.getStringList('issues_$customerEmail') ?? [];
      issuesJson.add(jsonEncode(issue.toJson()));
      await prefs.setStringList('issues_$customerEmail', issuesJson);
    }
  }

  Future<void> _trackActivity(String action, String details, String type) async {
    final customerEmail = await _getCurrentCustomerEmail();
    if (customerEmail == null) return;

    final activity = CustomerActivity(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now().toIso8601String().split('T')[0],
      action: action,
      details: details,
      platform: 'Flutter App',
      type: type,
    );

    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getStringList('activities_$customerEmail') ?? [];
    activitiesJson.add(jsonEncode(activity.toJson()));
    await prefs.setStringList('activities_$customerEmail', activitiesJson);
  }

  Future<String?> _getCurrentCustomerEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_customer_email');
  }

  CustomerAnalytics _calculateAnalytics(List<CustomerOrder> orders) {
    if (orders.isEmpty) {
      return CustomerAnalytics(
        totalOrders: 0,
        totalSpent: 0,
        avgOrderValue: 0,
        loyaltyStatus: 'New Customer',
        customerSince: DateTime.now().toIso8601String().split('T')[0],
        favoriteCategory: 'General',
      );
    }

    final totalSpent = orders.fold<double>(0, (sum, order) => sum + order.totalAmount);
    final avgOrderValue = totalSpent / orders.length;

    // Determine loyalty status based on total spent
    String loyaltyStatus;
    if (totalSpent >= 10000) {
      loyaltyStatus = 'Gold';
    } else if (totalSpent >= 5000) {
      loyaltyStatus = 'Silver';
    } else if (totalSpent >= 1000) {
      loyaltyStatus = 'Bronze';
    } else {
      loyaltyStatus = 'New Customer';
    }

    // Find most common category (simplified)
    final categories = orders
        .expand((order) => order.items)
        .map((item) => _getCategoryFromProduct(item.productName))
        .toList();
    
    final favoriteCategory = categories.isNotEmpty ? categories.first : 'General';

    // Get customer since date (first order date)
    orders.sort((a, b) => a.orderDate.compareTo(b.orderDate));
    final customerSince = orders.first.orderDate.split('T')[0];

    return CustomerAnalytics(
      totalOrders: orders.length,
      totalSpent: totalSpent,
      avgOrderValue: avgOrderValue,
      loyaltyStatus: loyaltyStatus,
      customerSince: customerSince,
      favoriteCategory: favoriteCategory,
    );
  }

  String _getCategoryFromProduct(String productName) {
    final name = productName.toLowerCase();
    if (name.contains('phone') || name.contains('case')) return 'Mobile Accessories';
    if (name.contains('earbuds') || name.contains('speaker')) return 'Audio';
    if (name.contains('power bank') || name.contains('charger')) return 'Electronics';
    return 'General';
  }

  // Mock SalesIQ methods - Replace with actual SalesIQ SDK calls when available
  
  static Future<void> _initializeMockSalesIQ(String appKey, String accessKey) async {
    // Mock initialization - replace with actual SalesIQ SDK initialization
    if (_config?.enableLogging == true) {
      log('Mock SalesIQ initialized with appKey: $appKey');
    }
  }

  Future<void> _setMockVisitorInfo(
    String email,
    String name,
    String? phone,
    Map<String, String>? customFields,
  ) async {
    // Mock visitor info setting - replace with actual SalesIQ SDK call
    if (_config?.enableLogging == true) {
      log('Mock visitor info set: $name ($email)');
    }
  }

  Future<void> _showMockChat() async {
    // Mock chat display - replace with actual SalesIQ SDK call
    if (_config?.enableLogging == true) {
      log('Mock chat shown');
    }
  }

  Future<void> _hideMockChat() async {
    // Mock chat hiding - replace with actual SalesIQ SDK call
    if (_config?.enableLogging == true) {
      log('Mock chat hidden');
    }
  }
}
