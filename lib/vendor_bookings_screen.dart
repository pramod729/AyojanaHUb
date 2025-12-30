import 'package:ayojana_hub/auth_provider.dart';
import 'package:ayojana_hub/booking_model.dart';
import 'package:ayojana_hub/booking_provider.dart';
import 'package:ayojana_hub/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VendorBookingsScreen extends StatefulWidget {
  const VendorBookingsScreen({super.key});

  @override
  State<VendorBookingsScreen> createState() => _VendorBookingsScreenState();
}

class _VendorBookingsScreenState extends State<VendorBookingsScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBookings());
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    if (authProvider.user != null) {
      final vendor = await vendorProvider.getVendorByUserId(authProvider.user!.uid);
      if (!mounted) return;
      if (vendor != null) {
        await bookingProvider.loadVendorBookings(vendor.id);
      }
    }
  }

  List<BookingModel> _filterBookings(List<BookingModel> bookings) {
    if (_selectedFilter == 'all') return bookings;
    return bookings.where((b) => b.status.toLowerCase() == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedFilter == 'all',
                    onTap: () => setState(() => _selectedFilter = 'all'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pending',
                    isSelected: _selectedFilter == 'pending',
                    onTap: () => setState(() => _selectedFilter = 'pending'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Confirmed',
                    isSelected: _selectedFilter == 'confirmed',
                    onTap: () => setState(() => _selectedFilter = 'confirmed'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Completed',
                    isSelected: _selectedFilter == 'completed',
                    onTap: () => setState(() => _selectedFilter = 'completed'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Cancelled',
                    isSelected: _selectedFilter == 'cancelled',
                    onTap: () => setState(() => _selectedFilter = 'cancelled'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<BookingProvider>(
              builder: (context, bookingProvider, _) {
                if (bookingProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (bookingProvider.error != null && bookingProvider.bookings.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                          const SizedBox(height: 12),
                          Text(
                            bookingProvider.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadBookings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                            ),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredBookings = _filterBookings(bookingProvider.bookings);

                if (filteredBookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter == 'all'
                              ? 'No bookings yet'
                              : 'No $_selectedFilter bookings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bookings from customers will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadBookings,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return _VendorBookingCard(
                        booking: booking,
                        onRefresh: _loadBookings,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _VendorBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onRefresh;

  const _VendorBookingCard({
    required this.booking,
    required this.onRefresh,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'confirmed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }

  void _showBookingActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Update Booking Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (booking.status.toLowerCase() == 'pending') ...[
              _ActionButton(
                icon: Icons.check_circle,
                label: 'Confirm Booking',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _updateStatus(context, 'confirmed');
                },
              ),
              const SizedBox(height: 12),
              _ActionButton(
                icon: Icons.cancel,
                label: 'Decline Booking',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _updateStatus(context, 'cancelled');
                },
              ),
            ],
            if (booking.status.toLowerCase() == 'confirmed') ...[
              _ActionButton(
                icon: Icons.done_all,
                label: 'Mark as Completed',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _updateStatus(context, 'completed');
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String status) async {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final error = await bookingProvider.updateBookingStatus(booking.id, status);

    if (context.mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking $status successfully')),
        );
        onRefresh();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showBookingActions(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.customerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.eventName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(booking.status),
                          size: 16,
                          color: _getStatusColor(booking.status),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking.status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(booking.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _InfoRow(
                icon: Icons.business_center,
                label: booking.vendorCategory,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.calendar_today,
                label: DateFormat('MMM dd, yyyy').format(booking.eventDate),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'NPR ${booking.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ],
                  ),
                  if (booking.status.toLowerCase() == 'pending' ||
                      booking.status.toLowerCase() == 'confirmed')
                    TextButton.icon(
                      onPressed: () => _showBookingActions(context),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Manage'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63FF),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
