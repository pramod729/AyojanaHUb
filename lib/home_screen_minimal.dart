import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Minimal, premium homepage for AyojanaHub.
///
/// Drop `HomeScreenMinimal()` into your `MaterialApp.home` to preview.
class HomeScreenMinimal extends StatefulWidget {
  const HomeScreenMinimal({super.key});

  @override
  State<HomeScreenMinimal> createState() => _HomeScreenMinimalState();
}

class _HomeScreenMinimalState extends State<HomeScreenMinimal>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _entranceController;

  // Example data (replace with real data provider)
  final List<Map<String, dynamic>> upcomingEventsList = [];
  final List<Map<String, dynamic>> featuredVendorsList = List.generate(
    6,
    (i) => {
      'name': 'Vendor ${i + 1}',
      'category': 'Catering',
      'rating': 4.5 - (i % 3) * 0.5,
    },
  );

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _onCreateEvent() {
    // Hook for navigation to create-event flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Event tapped')),
    );
  }

  void _navigateTo(String route) {
    try {
      Navigator.of(context).pushNamed(route);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigate to $route not yet configured')),
      );
    }
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hello, Priya 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Plan your perfect event today',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _navigateTo('/profile'),
            child: Semantics(
              label: 'Open profile',
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF4F46E5),
                child: Text(
                  'P',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ScaleOnTap(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Your Next Event',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Weddings, parties, meetings & more',
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _onCreateEvent,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Event'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4F46E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActions() {
    final actions = [
      {'icon': Icons.event, 'label': 'My Events', 'route': '/events'},
      {'icon': Icons.store, 'label': 'Vendors', 'route': '/vendors'},
      {'icon': Icons.book, 'label': 'My Bookings', 'route': '/bookings'},
      {'icon': Icons.star, 'label': 'Favorites', 'route': '/favorites'},
    ];

    return SizedBox(
      height: 84,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final a = actions[i] as Map<String, dynamic>;
          return GestureDetector(
            onTap: () => _navigateTo(a['route'] as String),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Icon(
                    (a['icon'] as IconData?) ?? Icons.star,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 72,
                  child: Text(
                    a['label'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _upcomingEvents() {
    if (upcomingEventsList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming Events', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month, size: 44, color: Colors.black.withValues(alpha: 0.15)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('No events yet — start planning now!', style: GoogleFonts.inter()),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 36,
                          child: OutlinedButton(
                            onPressed: _onCreateEvent,
                            child: const Text('Create Event'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text('Upcoming Events', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              itemCount: upcomingEventsList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final e = upcomingEventsList[i];
                return Container(
                  width: 260,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e['name'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e['date'] ?? '', style: GoogleFonts.inter(color: Colors.black54)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Upcoming', style: GoogleFonts.inter(fontSize: 12, color: Colors.green.shade700)),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _featuredVendors() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Vendors', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              TextButton(onPressed: () => _navigateTo('/vendors'), child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featuredVendorsList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final v = featuredVendorsList[i];
                return Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(width: 72, height: 72, color: Colors.grey.shade200),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(v['category'] as String, style: GoogleFonts.inter(color: Colors.black54, fontSize: 13)),
                            const Spacer(),
                            Row(children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 6),
                              Text('${v['rating']}', style: GoogleFonts.inter(fontSize: 13)),
                            ])
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entrance = Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOut));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: FadeTransition(
          opacity: _entranceController,
          child: SlideTransition(
            position: entrance,
            child: Column(
              children: [
                _topBar(),
                const SizedBox(height: 6),
                _heroCard(),
                const SizedBox(height: 10),
                _quickActions(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _upcomingEvents(),
                        _featuredVendors(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          final routes = ['/home', '/events', '/vendors', '/profile'];
          _navigateTo(routes[i]);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Vendors'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Small helper widget that applies a subtle scale-on-tap animation.
class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const ScaleOnTap({super.key, required this.child, this.onTap});

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(vsync: this, duration: const Duration(milliseconds: 90), lowerBound: 0.0, upperBound: 0.03);
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _down(_) => _ctl.forward();
  void _up(_) {
    _ctl.reverse();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: () => _ctl.reverse(),
      child: AnimatedBuilder(
        animation: _ctl,
        builder: (context, child) {
          final scale = 1 - _ctl.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
