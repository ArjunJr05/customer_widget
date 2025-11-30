import 'package:flutter_test/flutter_test.dart';
import 'package:salesiq_customer_widget/salesiq_customer_widget.dart';

void main() {
  group('SalesIQ Customer Widget Tests', () {
    test('SalesIQConfig validation works correctly', () {
      // Test valid configuration
      final validConfig = SalesIQConfig.production(
        webhookUrl: 'https://example.com/webhook',
        salesiqAppKey: 'test_app_key',
        salesiqAccessKey: 'test_access_key',
      );
      
      expect(validConfig.isValid, isTrue);
      expect(validConfig.webhookUrl, equals('https://example.com/webhook'));
      
      // Test invalid configuration
      final invalidConfig = SalesIQConfig.production(
        webhookUrl: '',
        salesiqAppKey: 'test_app_key',
        salesiqAccessKey: 'test_access_key',
      );
      
      expect(invalidConfig.isValid, isFalse);
    });

    test('CustomerOrder model creates correctly', () {
      final order = CustomerOrder(
        id: 'TEST123',
        customerName: 'Test Customer',
        customerEmail: 'test@example.com',
        items: [
          OrderItem(
            productName: 'Test Product',
            price: 100.0,
            quantity: 1,
          ),
        ],
        totalAmount: 100.0,
        status: 'confirmed',
        paymentStatus: 'paid',
        paymentMethod: 'Credit Card',
        orderDate: DateTime.now().toIso8601String(),
        trackingNumber: 'TRACK123',
        shippingAddress: '123 Test St',
      );

      expect(order.id, equals('TEST123'));
      expect(order.totalAmount, equals(100.0));
      expect(order.items.length, equals(1));
      expect(order.items.first.productName, equals('Test Product'));
    });

    test('SupportIssue model creates correctly', () {
      final issue = SupportIssue(
        id: 'ISSUE123',
        issueType: 'Product Issue',
        description: 'Test description',
        status: 'open',
        priority: 'high',
        createdAt: DateTime.now().toIso8601String(),
      );

      expect(issue.id, equals('ISSUE123'));
      expect(issue.issueType, equals('Product Issue'));
      expect(issue.status, equals('open'));
      expect(issue.priority, equals('high'));
    });
  });
}
