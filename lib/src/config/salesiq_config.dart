/// Configuration class for SalesIQ Customer Widget
class SalesIQConfig {
  final String webhookUrl;
  final String salesiqAppKey;
  final String salesiqAccessKey;
  final bool enableLogging;
  final Duration cacheTimeout;

  const SalesIQConfig({
    required this.webhookUrl,
    required this.salesiqAppKey,
    required this.salesiqAccessKey,
    this.enableLogging = false,
    this.cacheTimeout = const Duration(minutes: 5),
  });

  /// Create config for development environment
  factory SalesIQConfig.development({
    required String webhookUrl,
    required String salesiqAppKey,
    required String salesiqAccessKey,
  }) {
    return SalesIQConfig(
      webhookUrl: webhookUrl,
      salesiqAppKey: salesiqAppKey,
      salesiqAccessKey: salesiqAccessKey,
      enableLogging: true,
      cacheTimeout: const Duration(minutes: 1),
    );
  }

  /// Create config for production environment
  factory SalesIQConfig.production({
    required String webhookUrl,
    required String salesiqAppKey,
    required String salesiqAccessKey,
  }) {
    return SalesIQConfig(
      webhookUrl: webhookUrl,
      salesiqAppKey: salesiqAppKey,
      salesiqAccessKey: salesiqAccessKey,
      enableLogging: false,
      cacheTimeout: const Duration(minutes: 10),
    );
  }

  /// Validate configuration
  bool get isValid {
    return webhookUrl.isNotEmpty &&
           salesiqAppKey.isNotEmpty &&
           salesiqAccessKey.isNotEmpty &&
           Uri.tryParse(webhookUrl) != null;
  }

  /// Get webhook endpoint URL
  String get customerDataEndpoint => '$webhookUrl/api/customer';

  /// Get webhook URL for SalesIQ
  String get salesiqWebhookUrl => '$webhookUrl/webhook';

  @override
  String toString() {
    return 'SalesIQConfig(webhookUrl: $webhookUrl, enableLogging: $enableLogging)';
  }
}
