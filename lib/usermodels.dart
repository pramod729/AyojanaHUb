import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? profileImage;
  final DateTime createdAt;
  // Vendor-specific fields
  final String? vendorCategory;
  final String? vendorDescription;
  final String? vendorLocation;
  final List<String>? vendorServices;
  final String? businessName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImage,
    required this.createdAt,
    this.vendorCategory,
    this.vendorDescription,
    this.vendorLocation,
    this.vendorServices,
    this.businessName,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'customer',
      profileImage: map['profileImage'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      vendorCategory: map['vendorCategory'],
      vendorDescription: map['vendorDescription'],
      vendorLocation: map['vendorLocation'],
      vendorServices: map['vendorServices'] != null ? List<String>.from(map['vendorServices']) : null,
      businessName: map['businessName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profileImage': profileImage,
      'createdAt': Timestamp.fromDate(createdAt),
      'vendorCategory': vendorCategory,
      'vendorDescription': vendorDescription,
      'vendorLocation': vendorLocation,
      'vendorServices': vendorServices,
      'businessName': businessName,
    };
  }
}