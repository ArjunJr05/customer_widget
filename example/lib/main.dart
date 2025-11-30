import 'package:flutter/material.dart';
import 'package:salesiq_customer_widget/salesiq_customer_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SalesIQ Customer Widget
  await SalesIQCustomerService.initialize(
    SalesIQConfig.development(
      webhookUrl: 'https://your-ngrok-url.ngrok-free.dev',
      salesiqAppKey: 'your_salesiq_app_key',
      salesiqAccessKey: 'your_salesiq_access_key',
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SalesIQ Customer Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ECommerceDemo(),
    );
  }
}

class ECommerceDemo extends StatefulWidget {
  const ECommerceDemo({super.key});

  @override
  State<ECommerceDemo> createState() => _ECommerceDemoState();
}

class _ECommerceDemoState extends State<ECommerceDemo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoggedIn = false;
  String _customerEmail = '';
  String _customerName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Commerce Demo'),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: () => SalesIQCustomerService.instance.showChat(),
            ),
        ],
      ),
      body: _isLoggedIn ? _buildECommerceScreen() : _buildLoginScreen(),
    );
  }

  Widget _buildLoginScreen() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Demo Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
          SizedBox(height: 16),
          Text('Demo Users:'),
          TextButton(
            onPressed: () {
              _nameController.text = 'Priya Sharma';
              _emailController.text = 'priya@gmail.com';
            },
            child: Text('Priya Sharma (Silver Member)'),
          ),
          TextButton(
            onPressed: () {
              _nameController.text = 'John Doe';
              _emailController.text = 'john@example.com';
            },
            child: Text('John Doe (New Customer)'),
          ),
        ],
      ),
    );
  }

  Widget _buildECommerceScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, $_customerName!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 24),
          Text(
            'Featured Products',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          _buildProductGrid(),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _placeOrder,
                  icon: Icon(Icons.shopping_cart),
                  label: Text('Place Sample Order'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _reportIssue,
                  icon: Icon(Icons.report_problem),
                  label: Text('Report Issue'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => SalesIQCustomerService.instance.showChat(),
              icon: Icon(Icons.chat),
              label: Text('Contact Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: _logout,
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = [
      {'name': 'iPhone Case - Blue', 'price': '₹599'},
      {'name': 'Power Bank 10000mAh', 'price': '₹1299'},
      {'name': 'Wireless Earbuds Pro', 'price': '₹2999'},
      {'name': 'Screen Protector', 'price': '₹299'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android, size: 48, color: Colors.blue),
                SizedBox(height: 8),
                Text(
                  product['name']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  product['price']!,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _login() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter name and email')),
      );
      return;
    }

    _customerName = _nameController.text;
    _customerEmail = _emailController.text;

    // Set customer info in SalesIQ
    await SalesIQCustomerService.instance.setCustomerInfo(
      email: _customerEmail,
      name: _customerName,
      phone: '+91 9876543210',
    );

    setState(() {
      _isLoggedIn = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged in successfully! Customer data is now available in SalesIQ.')),
    );
  }

  Future<void> _placeOrder() async {
    final order = CustomerOrder(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      customerName: _customerName,
      customerEmail: _customerEmail,
      items: [
        OrderItem(
          productName: 'iPhone Case - Blue',
          price: 599.0,
          quantity: 1,
        ),
        OrderItem(
          productName: 'Screen Protector',
          price: 299.0,
          quantity: 1,
        ),
      ],
      totalAmount: 898.0,
      status: 'confirmed',
      paymentStatus: 'paid',
      paymentMethod: 'UPI',
      orderDate: DateTime.now().toIso8601String(),
      trackingNumber: 'TRK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      shippingAddress: '123 Main Street, City, State 12345',
    );

    await SalesIQCustomerService.instance.trackOrder(order);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed! Check SalesIQ widget for updated data.')),
    );
  }

  Future<void> _reportIssue() async {
    final issue = SupportIssue(
      id: 'ISS${DateTime.now().millisecondsSinceEpoch}',
      issueType: 'Product Quality',
      description: 'Product received was damaged during shipping',
      status: 'Open',
      createdAt: DateTime.now().toIso8601String(),
      priority: 'High',
    );

    await SalesIQCustomerService.instance.trackIssue(issue);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Issue reported! Check SalesIQ widget for updated data.')),
    );
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _customerName = '';
      _customerEmail = '';
      _nameController.clear();
      _emailController.clear();
    });
  }
}
