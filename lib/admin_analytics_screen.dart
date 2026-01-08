import 'package:ayojana_hub/admin_provider.dart';
import 'package:ayojana_hub/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AdminProvider>(context, listen: false);
      provider.fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.userModel;

    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (user.role != 'admin') return const Scaffold(body: Center(child: Text('Access denied')));

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Analytics')),
      body: Consumer<AdminProvider>(builder: (context, provider, _) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        if (provider.error != null) return Center(child: Text('Error: ${provider.error}'));

        return RefreshIndicator(
          onRefresh: () => provider.fetchStats(),
          child: ListView(padding: const EdgeInsets.all(16), children: [
            _statCard('Vendor Signups', provider.vendorSignups.toString(), Icons.storefront, Colors.teal),
            const SizedBox(height: 12),
            _statCard('Total Bookings', provider.totalBookings.toString(), Icons.book_online, Colors.indigo),
            const SizedBox(height: 12),
            _statCard('Completed Bookings', provider.completedBookings.toString(), Icons.check_circle_outline, Colors.green),
            const SizedBox(height: 12),
            _statCard('Total Revenue', '₹ ${provider.totalRevenue.toStringAsFixed(2)}', Icons.attach_money, Colors.orange),
          ]),
        );
      }),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
