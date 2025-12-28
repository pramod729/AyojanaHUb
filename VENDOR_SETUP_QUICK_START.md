# Vendor Registration System - Quick Setup Guide

## What's New

✅ **Vendor Self-Registration** - Vendors can now create their own accounts
✅ **Vendor Dashboard** - Dedicated dashboard for vendor account management
✅ **Profile Management** - Edit business information anytime
✅ **Role-Based Navigation** - Automatic routing based on user role (vendor/customer)

## Files Added/Modified

### New Files Created:
1. **lib/vendor_register_screen.dart** - Vendor registration form
2. **lib/vendor_dashboard_screen.dart** - Vendor dashboard and profile editor
3. **VENDOR_SELF_REGISTRATION_GUIDE.md** - Comprehensive documentation

### Files Modified:
1. **lib/usermodels.dart** - Added vendor profile fields
2. **lib/auth_provider.dart** - Added vendor registration and profile update methods
3. **lib/vendor_provider.dart** - Added vendor management methods
4. **lib/main.dart** - Added vendor routes
5. **lib/splash_screen.dart** - Updated role-based navigation
6. **lib/login_screen_new.dart** - Updated role-based navigation
7. **lib/register_screen_new.dart** - Added vendor registration link

## How to Use

### For Vendors to Register:

1. **From Login Screen:**
   - Tap "Register" button
   - Tap "Are you a vendor? Register Here" link

2. **Fill Out the Form:**
   - Personal Information (Name, Email, Phone, Password)
   - Business Information (Business Name, Category, Location, Description)
   - Select Services (at least one required)

3. **Verify Account:**
   - Account is created with `role: 'vendor'`
   - Redirect to login screen
   - Login with vendor credentials
   - Automatically taken to Vendor Dashboard

### For Vendors to Manage Profile:

1. **Login as Vendor**
   - Uses same login screen as customers
   - Automatically routed to Vendor Dashboard

2. **From Dashboard:**
   - View complete business profile
   - Tap "Edit Business Profile" to update
   - Update any field (business name, category, services, etc.)
   - Changes saved immediately

3. **Dashboard Features:**
   - Edit Business Profile
   - Manage Portfolio (coming soon)
   - View Bookings
   - View Reviews & Ratings (coming soon)
   - Logout

## Testing the System

### Quick Test Steps:

1. **Test Customer Registration (Existing Flow):**
   ```
   Login → Register → Fill customer details → Success
   Navigate to Home Screen
   ```

2. **Test Vendor Registration (New Flow):**
   ```
   Login → Register → "Are you a vendor? Register Here" 
   → Fill vendor form → Success → Login → Vendor Dashboard
   ```

3. **Test Vendor Profile Update:**
   ```
   Login as Vendor → Dashboard → Edit Profile → Update fields → Save
   → Profile updated in real-time
   ```

## API Reference

### AuthProvider Methods:

```dart
// Register account (customer or vendor)
register({
  required String name,
  required String email,
  required String password,
  required String phone,
  String role = 'customer'  // 'vendor' for vendors
})

// Update vendor profile
updateVendorProfile({
  required String businessName,
  required String category,
  required String description,
  required String location,
  required List<String> services,
})
```

### VendorProvider Methods:

```dart
// Get vendor by user ID
getVendorByUserId(String userId)

// Update vendor profile from user data
updateVendorProfileFromUser({
  required String userId,
  required String businessName,
  required String category,
  required String description,
  required String phone,
  required String email,
  required String location,
  required List<String> services,
})

// Delete vendor
deleteVendor(String vendorId)

// Upload portfolio image
uploadVendorPortfolioImage(String vendorId, String imageUrl)
```

## Business Categories Available

- **Catering** - Food & beverage services
- **Photography** - Photography and videography
- **DJ & Music** - Entertainment services
- **Decoration** - Event decoration services
- **Venue** - Event venue rental
- **Planning** - Event planning services

Each category has 5-6 predefined services to choose from.

## Firestore Rules (Recommended)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Vendors can read/write their own vendor documents
    match /vendors/{vendorId} {
      allow read: if true;  // Everyone can view vendor profiles
      allow write: if request.auth.uid == resource.data.userId;  // Only vendor can edit
      allow create: if request.auth.uid != null;  // Authenticated users can create
    }
  }
}
```

## Troubleshooting

### Issue: Vendor not routed to dashboard after login
**Solution:** Check that user's `role` field in Firestore is set to 'vendor'

### Issue: Services not showing based on category
**Solution:** Verify `vendorServices` list is populated during registration

### Issue: Profile updates not reflecting
**Solution:** Ensure `updateVendorProfile()` completes successfully

## Next Steps

1. **Test the complete flow** in development
2. **Update Firestore security rules** (see recommendations above)
3. **Add image upload capability** to portfolio management
4. **Implement booking management** features
5. **Add review/rating system** for vendors
6. **Create analytics dashboard** for vendor insights

## Support

For issues or questions, refer to:
- [VENDOR_SELF_REGISTRATION_GUIDE.md](./VENDOR_SELF_REGISTRATION_GUIDE.md) - Comprehensive documentation
- Code comments in each modified file
- Existing code patterns in the app

---

**Status:** ✅ Complete and Ready for Testing
**Last Updated:** December 28, 2025
