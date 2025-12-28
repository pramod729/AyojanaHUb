import 'package:ayojana_hub/package_model.dart';
import 'package:ayojana_hub/vendor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<VendorModel> _vendors = [];
  List<PackageModel> _packages = [];
  bool _isLoading = false;
  String? _error;

  List<VendorModel> get vendors => _vendors;
  List<PackageModel> get packages => _packages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Sample vendor data
  static const List<Map<String, dynamic>> _sampleVendors = [
    {
      'name': 'Golden Plate Catering',
      'category': 'Catering',
      'description': 'Premium catering service with multi-cuisine options',
      'phone': '+91-9876543210',
      'email': 'info@goldenplate.com',
      'location': 'Mumbai, Maharashtra',
      'services': ['North Indian', 'South Indian', 'Continental', 'Chinese'],
      'rating': 4.8,
      'reviewCount': 245,
      'profileImage': 'https://via.placeholder.com/200?text=Golden+Plate',
      'portfolioImages': ['https://via.placeholder.com/300?text=Event1', 'https://via.placeholder.com/300?text=Event2'],
    },
    {
      'name': 'Click Moments Photography',
      'category': 'Photography',
      'description': 'Professional wedding and event photography',
      'phone': '+91-9876543211',
      'email': 'contact@clickmoments.com',
      'location': 'Delhi, Delhi',
      'services': ['Wedding Photography', 'Candid Photography', 'Video Coverage'],
      'rating': 4.9,
      'reviewCount': 312,
      'profileImage': 'https://via.placeholder.com/200?text=Click+Moments',
      'portfolioImages': ['https://via.placeholder.com/300?text=Photo1', 'https://via.placeholder.com/300?text=Photo2'],
    },
    {
      'name': 'DJ Beats Entertainment',
      'category': 'DJ & Music',
      'description': 'Best DJ and live music services for all occasions',
      'phone': '+91-9876543212',
      'email': 'bookings@djbeats.com',
      'location': 'Bangalore, Karnataka',
      'services': ['DJ Service', 'Live Band', 'Sound System', 'Lighting'],
      'rating': 4.7,
      'reviewCount': 189,
      'profileImage': 'https://via.placeholder.com/200?text=DJ+Beats',
      'portfolioImages': ['https://via.placeholder.com/300?text=DJ1', 'https://via.placeholder.com/300?text=DJ2'],
    },
    {
      'name': 'Floral Dreams Decoration',
      'category': 'Decoration',
      'description': 'Creative and elegant decoration solutions',
      'phone': '+91-9876543213',
      'email': 'design@floraldecorations.com',
      'location': 'Pune, Maharashtra',
      'services': ['Stage Decoration', 'Flower Arrangements', 'Thematic Decor', 'Lighting Design'],
      'rating': 4.6,
      'reviewCount': 156,
      'profileImage': 'https://via.placeholder.com/200?text=Floral+Dreams',
      'portfolioImages': ['https://via.placeholder.com/300?text=Decor1', 'https://via.placeholder.com/300?text=Decor2'],
    },
    {
      'name': 'Grand Banquets',
      'category': 'Venue',
      'description': 'Luxurious banquet hall with complete event management',
      'phone': '+91-9876543214',
      'email': 'events@grandbanquets.com',
      'location': 'Hyderabad, Telangana',
      'services': ['Indoor Venue', 'Outdoor Venue', 'Catering Available', 'Event Management'],
      'rating': 4.8,
      'reviewCount': 428,
      'profileImage': 'https://via.placeholder.com/200?text=Grand+Banquets',
      'portfolioImages': ['https://via.placeholder.com/300?text=Venue1', 'https://via.placeholder.com/300?text=Venue2'],
    },
    {
      'name': 'Elite Event Planners',
      'category': 'Planning',
      'description': 'Full-service event planning and coordination',
      'phone': '+91-9876543215',
      'email': 'plan@eliteevents.com',
      'location': 'Jaipur, Rajasthan',
      'services': ['Complete Planning', 'Vendor Coordination', 'Day Management', 'Custom Themes'],
      'rating': 4.9,
      'reviewCount': 367,
      'profileImage': 'https://via.placeholder.com/200?text=Elite+Planners',
      'portfolioImages': ['https://via.placeholder.com/300?text=Plan1', 'https://via.placeholder.com/300?text=Plan2'],
    },
  ];

  Future<void> _initializeSampleVendors() async {
    try {
      final snapshot = await _firestore.collection('vendors').limit(1).get();
      
      // If no vendors exist, add sample vendors
      if (snapshot.docs.isEmpty) {
        for (var vendor in _sampleVendors) {
          await _firestore.collection('vendors').add(vendor);
        }
      }
    } catch (e) {
      print('Error initializing sample vendors: $e');
    }
  }

  Future<void> loadVendors({String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Initialize sample vendors if collection is empty
      await _initializeSampleVendors();

      Query query = _firestore.collection('vendors');
      
      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.get();
      _vendors = snapshot.docs
          .map((doc) => VendorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error loading vendors: $e');
      _error = 'Failed to load vendors: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadVendorPackages(String vendorId) async {
    try {
      final snapshot = await _firestore
          .collection('packages')
          .where('vendorId', isEqualTo: vendorId)
          .get();

      _packages = snapshot.docs
          .map((doc) => PackageModel.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading packages: $e');
    }
  }

  Future<String?> createVendor(VendorModel vendor) async {
    try {
      final docRef = await _firestore.collection('vendors').add({
        'name': vendor.name,
        'category': vendor.category,
        'description': vendor.description,
        'phone': vendor.phone,
        'email': vendor.email,
        'location': vendor.location,
        'services': vendor.services,
        'rating': vendor.rating,
        'reviewCount': vendor.reviewCount,
        'profileImage': vendor.profileImage,
        'portfolioImages': vendor.portfolioImages,
      });
      
      print('Vendor created successfully with ID: ${docRef.id}');
      
      // Refresh vendor list
      await loadVendors();
      return null;
    } catch (e) {
      print('Error creating vendor: $e');
      return 'Failed to register vendor: $e';
    }
  }
}

