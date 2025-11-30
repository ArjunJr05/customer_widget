# 🚀 SalesIQ Customer Widget - Setup Guide for App Makers

## 📋 What You'll Get

After setup, your SalesIQ agents will instantly see:
- 📦 **All customer orders** with status, payment, tracking
- 💳 **Payment information** (Paid/Pending/COD/Failed)
- 🎫 **Support history** and open issues
- 📊 **Customer analytics** (loyalty status, total spent, order count)
- ⚡ **Zero search time** - data appears automatically when customer chats

## 🎯 Step 1: Add Package to Your Flutter App

### pubspec.yaml
```yaml
dependencies:
  salesiq_customer_widget: ^1.0.0
  # Your existing dependencies...
```

### main.dart
```dart
import 'package:salesiq_customer_widget/salesiq_customer_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SalesIQ Customer Widget
  await SalesIQCustomerService.initialize(
    SalesIQConfig.production(
      webhookUrl: 'https://your-webhook-server.com',
      salesiqAppKey: 'your_salesiq_app_key',
      salesiqAccessKey: 'your_salesiq_access_key',
    ),
  );
  
  runApp(MyApp());
}
```

## 🔧 Step 2: Set Up Webhook Server

### Download and Setup
```bash
# 1. Download our webhook server
curl -O https://github.com/yourusername/salesiq_customer_widget/raw/main/webhook/simple-customer-webhook.js

# 2. Install dependencies
npm install express cors

# 3. Start server
node simple-customer-webhook.js

# 4. For production, deploy to Heroku/Vercel/AWS
```

### Production Deployment Options

#### Option A: Heroku (Recommended)
```bash
# 1. Create Heroku app
heroku create your-app-salesiq-webhook

# 2. Deploy
git add .
git commit -m "Add SalesIQ webhook"
git push heroku main

# 3. Your webhook URL: https://your-app-salesiq-webhook.herokuapp.com
```

#### Option B: Vercel
```bash
# 1. Install Vercel CLI
npm i -g vercel

# 2. Deploy
vercel

# 3. Your webhook URL: https://your-project.vercel.app
```

#### Option C: AWS/DigitalOcean
- Deploy as Node.js application
- Ensure port 3000 is accessible
- Use PM2 for process management

## 🎯 Step 3: Configure SalesIQ Widget

### 1. Login to Zoho SalesIQ
- Go to [salesiq.zoho.com](https://salesiq.zoho.com)
- Navigate to **Settings** → **Widgets**

### 2. Create New Widget
- Click **"Create Widget"**
- Select **"Webhook"** type
- Name: "Customer Data Widget"

### 3. Configure Webhook
- **Webhook URL**: `https://your-webhook-server.com/webhook`
- **Method**: POST
- **Trigger**: When visitor starts chat
- **Authentication**: None (or add if needed)

### 4. Test Widget
- Click **"Preview"**
- Select a test customer
- Verify customer data appears

## 📱 Step 4: Integrate in Your App

### Set Customer Info (Login)
```dart
// When user logs in
await SalesIQCustomerService.instance.setCustomerInfo(
  email: user.email,
  name: user.name,
  phone: user.phone,
);
```

### Track Orders (Checkout)
```dart
// When customer places order
final order = CustomerOrder(
  id: orderId,
  customerName: customerName,
  customerEmail: customerEmail,
  items: cartItems.map((item) => OrderItem(
    productName: item.name,
    price: item.price,
    quantity: item.quantity,
  )).toList(),
  totalAmount: totalAmount,
  status: 'confirmed',
  paymentStatus: paymentSuccessful ? 'paid' : 'pending',
  paymentMethod: selectedPaymentMethod,
  orderDate: DateTime.now().toIso8601String(),
  trackingNumber: generateTrackingNumber(),
);

await SalesIQCustomerService.instance.trackOrder(order);
```

### Track Support Issues
```dart
// When customer reports issue
final issue = SupportIssue(
  id: generateIssueId(),
  orderId: relatedOrderId, // optional
  issueType: selectedIssueType,
  description: customerDescription,
  status: 'Open',
  createdAt: DateTime.now().toIso8601String(),
  priority: determinePriority(issueType),
);

await SalesIQCustomerService.instance.trackIssue(issue);
```

### Show Support Chat
```dart
// Add support button in your app
FloatingActionButton(
  onPressed: () => SalesIQCustomerService.instance.showChat(),
  child: Icon(Icons.chat),
  backgroundColor: Colors.green,
)
```

## 🎯 Step 5: Customize for Your Business

### Order Status Mapping
```dart
// Map your order statuses to display-friendly names
String getDisplayStatus(String internalStatus) {
  switch (internalStatus) {
    case 'processing': return 'confirmed';
    case 'shipped': return 'shipped';
    case 'out_for_delivery': return 'outForDelivery';
    case 'completed': return 'delivered';
    default: return internalStatus;
  }
}
```

### Payment Method Mapping
```dart
// Map your payment methods
String getPaymentMethod(String method) {
  switch (method) {
    case 'card': return 'Credit Card';
    case 'upi': return 'UPI';
    case 'wallet': return 'Digital Wallet';
    case 'cod': return 'Cash on Delivery';
    default: return method;
  }
}
```

### Custom Issue Types
```dart
final issueTypes = [
  'Product Quality',
  'Delivery Issue',
  'Payment Problem',
  'Wrong Item',
  'Damaged Product',
  'Refund Request',
  'General Inquiry',
];
```

## 🔧 Step 6: Database Integration (Advanced)

### Replace Mock Data with Real Database
```dart
// In your webhook server (simple-customer-webhook.js)
async function getCustomerData(customerEmail) {
  // Replace this with your database query
  const customer = await db.query(`
    SELECT * FROM customers WHERE email = ?
  `, [customerEmail]);
  
  const orders = await db.query(`
    SELECT * FROM orders WHERE customer_email = ?
    ORDER BY created_at DESC
  `, [customerEmail]);
  
  const issues = await db.query(`
    SELECT * FROM support_tickets WHERE customer_email = ?
  `, [customerEmail]);
  
  return {
    customerEmail,
    customerName: customer.name,
    orders: orders.map(formatOrder),
    issues: issues.map(formatIssue),
    analytics: calculateAnalytics(orders),
  };
}
```

## 📊 Step 7: Monitor and Optimize

### Track Success Metrics
- **Support Resolution Time**: Before vs After
- **Customer Satisfaction**: Survey scores
- **Agent Productivity**: Tickets handled per hour
- **First Contact Resolution**: Percentage improvement

### Performance Optimization
- **Cache customer data** for 5-10 minutes
- **Limit order history** to last 10 orders
- **Compress webhook responses**
- **Use CDN** for webhook server

## 🚨 Troubleshooting

### Common Issues

#### 1. Widget Not Showing Data
```bash
# Check webhook server is running
curl https://your-webhook-server.com/webhook

# Check SalesIQ widget configuration
# Verify webhook URL is correct
```

#### 2. Customer Data Not Found
```dart
// Ensure customer info is set before chat
await SalesIQCustomerService.instance.setCustomerInfo(
  email: email,
  name: name,
);

// Check local storage
final prefs = await SharedPreferences.getInstance();
print(prefs.getKeys()); // Should show customer data keys
```

#### 3. Orders Not Appearing
```dart
// Verify order tracking
await SalesIQCustomerService.instance.trackOrder(order);

// Check order data format
print(order.toJson()); // Verify all required fields
```

### Debug Mode
```dart
// Enable debug logging
SalesIQConfig.development(
  webhookUrl: 'your-url',
  salesiqAppKey: 'your-key',
  salesiqAccessKey: 'your-secret',
  // enableLogging: true is automatic in development
);
```

## 🎉 Success Checklist

- [ ] Package added to pubspec.yaml
- [ ] SalesIQ initialized in main.dart
- [ ] Webhook server deployed and accessible
- [ ] SalesIQ widget configured with webhook URL
- [ ] Customer info set on login
- [ ] Orders tracked on checkout
- [ ] Support issues tracked when reported
- [ ] Chat button added to app
- [ ] Tested end-to-end flow
- [ ] Production deployment completed

## 🆘 Support

### Need Help?
- 📧 **Email**: support@yourcompany.com
- 💬 **GitHub**: [Create an issue](https://github.com/yourusername/salesiq_customer_widget/issues)
- 📖 **Docs**: [Full documentation](https://docs.yourcompany.com)
- 🎥 **Video Tutorial**: [YouTube playlist](https://youtube.com/playlist)

### Professional Setup Service
We offer professional setup service for:
- Custom webhook server deployment
- Database integration
- SalesIQ configuration
- Team training

**Contact us for a quote!**

---

## 🏆 You're All Set!

Your customer support team now has **instant access** to complete customer data. No more asking "What's your order ID?" - agents can provide **personalized, efficient support** from the first message!

**Welcome to the future of customer support!** 🚀
