import 'package:ayojana_hub/vendor_provider.dart';
import 'package:ayojana_hub/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateVendorScreen extends StatefulWidget {
  const CreateVendorScreen({super.key});

  @override
  State<CreateVendorScreen> createState() => _CreateVendorScreenState();
}

class _CreateVendorScreenState extends State<CreateVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vendorNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _servicesController = TextEditingController();
  
  String _selectedCategory = 'Catering';
  List<String> _selectedServices = [];
  bool _isLoading = false;
  
  final List<String> _categories = [
    'Catering',
    'Photography',
    'DJ & Music',
    'Decoration',
    'Venue',
    'Planning',
  ];

  final Map<String, List<String>> _servicesByCategory = {
    'Catering': ['North Indian', 'South Indian', 'Continental', 'Chinese', 'Desserts', 'Beverages'],
    'Photography': ['Wedding Photography', 'Candid Photography', 'Video Coverage', 'Pre-wedding', 'Drone Photography'],
    'DJ & Music': ['DJ Service', 'Live Band', 'Sound System', 'Lighting', 'MC Service'],
    'Decoration': ['Stage Decoration', 'Flower Arrangements', 'Thematic Decor', 'Lighting Design', 'Setup & Dismantling'],
    'Venue': ['Indoor Venue', 'Outdoor Venue', 'Catering Available', 'Event Management', 'Parking'],
    'Planning': ['Complete Planning', 'Vendor Coordination', 'Day Management', 'Custom Themes', 'Budget Management'],
  };

  @override
  void dispose() {
    _vendorNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  Future<void> _createVendor() async {
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one service')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);

    final vendor = VendorModel(
      id: '',
      name: _vendorNameController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      location: _locationController.text.trim(),
      services: _selectedServices,
      rating: 5.0,
      reviewCount: 0,
      profileImage: null,
      portfolioImages: [],
    );

    print('Creating vendor: ${vendor.name}');
    final error = await vendorProvider.createVendor(vendor);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } else {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Vendor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Category',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                        _selectedServices.clear();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Vendor Name
              TextFormField(
                controller: _vendorNameController,
                decoration: InputDecoration(
                  labelText: 'Business Name',
                  prefixIcon: const Icon(Icons.business),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location / City',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Business Description',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Services Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Services Offered',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (_servicesByCategory[_selectedCategory] ?? []).map((service) {
                      final isSelected = _selectedServices.contains(service);
                      return FilterChip(
                        label: Text(service),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedServices.add(service);
                            } else {
                              _selectedServices.remove(service);
                            }
                          });
                        },
                        selectedColor: const Color(0xFF6C63FF),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _createVendor,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Register Vendor',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
