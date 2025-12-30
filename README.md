# AyojanaHub - Event Planning & Vendor Bidding Platform

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-orange?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)

A modern event planning and vendor bidding platform built with Flutter. Connect event organizers with vendors through a competitive proposal system.

[Features](#features) • [How It Works](#how-it-works) • [Installation](#installation) • [Setup](#setup) • [Architecture](#architecture)

</div>

---

## 📋 Overview

**AyojanaHub** is a comprehensive event planning platform that connects event organizers with service vendors through a competitive bidding system. Users create events, vendors submit proposals, and the best proposal wins - creating a marketplace for event services.

### Key Highlights
- 🎯 **Proposal-Based Bidding** - Vendors compete with proposals for events
- 🔐 **Dual User Roles** - Customer and Vendor accounts with different workflows
- 📱 **Cross-Platform** - Android, iOS, Web support
- 🎨 **Modern UI** - Clean, professional design with smooth animations
- ⚡ **Real-time Updates** - Firebase Firestore for instant notifications
- 🔔 **Smart Matching** - Auto-notify vendors based on service categories

---

## 🎯 How It Works

### For Event Organizers (Customers):

1. **Create an Event** 
   - Enter event details (name, type, date, location, guest count)
   - System automatically determines required services based on event type
   - Budget and description for vendor reference

2. **Receive Proposals**
   - Matching vendors are notified automatically
   - Vendors submit proposals with pricing and service details
   - Review all proposals in one place

3. **Accept a Proposal**
   - Compare proposals side-by-side
   - Accept the best proposal
   - Booking is automatically created
   - Other proposals are auto-rejected

4. **View Bookings**
   - Track confirmed bookings
   - Event and vendor details
   - Booking status management

### For Vendors:

1. **Setup Vendor Profile**
   - Register as vendor with service category
   - Add business details and services offered
   - Set location and contact information

2. **Browse Opportunities**
   - See events matching your service category
   - Filter by event type, location, budget
   - View event details before bidding

3. **Submit Proposals**
   - Enter proposed price
   - List included services
   - Specify delivery timeline
   - Add detailed description

4. **Track Proposals**
   - Monitor submitted proposals
   - Get notified when accepted/rejected
   - View confirmed bookings

---

## ✨ Features

### 🔐 Authentication
- Dual role system (Customer/Vendor)
- Email & password authentication
- Password recovery
- Profile management
- Session persistence

### 🎉 Event Management (Customers)
- Create events with full details
- Auto-service matching by event type
- View proposal count
- Accept/reject proposals
- Track event status
- View all bookings

### 💼 Vendor Features
- Vendor profile creation
- Service category selection
- Event opportunity browsing
- Proposal submission
- Proposal tracking
- Booking management

### 📅 Booking System
- Auto-created from accepted proposals
- Track booking status
- View event and vendor details
- Booking history for both parties

### 👤 User Dashboard
- Profile management
- Event overview
- Booking tracking
- Notifications

---

## 🛠 Tech Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **Provider** - State management

### Backend & Services
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - File storage (future)

### UI/UX
- **Material Design 3** - Design system
- **Google Fonts** - Typography
- **Custom Theme** - Brand colors and components

---

## 📦 Installation

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase account
- Android Studio / VS Code
- Git

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/pramod729/AyojanaHUb.git
cd AyojanaHUb
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup Firebase**
   - Create a new Firebase project
   - Add Android/iOS apps to Firebase
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place configuration files in appropriate directories
   - Run FlutterFire configure (optional)

4. **Run the app**
```bash
flutter run
```

---

## 🏗 Architecture

### Data Models

**UserModel**
- Basic user info + role (customer/vendor)
- Vendor-specific fields (category, services, location, description)

**EventModel**
- Event details (name, type, date, location, guests, budget)
- Required services (auto-determined by event type)
- Proposal count
- Status tracking

**ProposalModel**
- Vendor proposal for an event
- Pricing and service details
- Status (pending/accepted/rejected)
- Timestamps

**BookingModel**
- Auto-created when proposal is accepted
- Links event, customer, and vendor
- Price and service details
- Status management

### App Flow

```
User Registration → [Choose Role] → Customer/Vendor Profile

CUSTOMER FLOW:
Create Event → Required Services Auto-Set → Matching Vendors Notified
               ↓
          Vendors Submit Proposals
               ↓
          Review Proposals → Accept Best One
               ↓
          Booking Auto-Created → Track in My Bookings

VENDOR FLOW:
Setup Profile → Browse Matching Opportunities → Submit Proposal
                                                      ↓
                                              Await Customer Decision
                                                      ↓
                                              Get Notified (Accept/Reject)
                                                      ↓
                                              View Confirmed Bookings
```

### Firebase Collections

- `users` - User profiles (customers and vendors)
- `events` - Event listings
- `proposals` - Vendor proposals for events
- `bookings` - Confirmed bookings
- `notifications` - User notifications

---

## 📱 Screens

### Customer Screens
- Home Dashboard
- Create Event
- My Events
- Event Detail (with proposals)
- Event Proposals (compare & accept)
- My Bookings
- Profile

### Vendor Screens
- Vendor Dashboard
- Event Opportunities (browse)
- Submit Proposal
- My Proposals
- Vendor Bookings
- Profile

### Shared Screens
- Login
- Register (Customer/Vendor)
- Forgot Password
- Splash Screen

---

## 🔥 Key Features Implementation

### Auto-Vendor Matching
When an event is created, the system:
1. Determines required services based on event type
2. Queries vendors with matching categories
3. Creates notifications for matching vendors
4. Vendors see opportunities in their dashboard

### Proposal System
- Vendors submit competitive proposals
- Customers compare all proposals
- Accept one → Others auto-rejected
- Booking auto-created on acceptance

### Smart Status Management
- Events: `awaiting_proposals` → `confirmed`
- Proposals: `pending` → `accepted/rejected`
- Bookings: `confirmed` → `completed/cancelled`

---

## 🚀 Future Enhancements

- [ ] Push notifications
- [ ] In-app messaging
- [ ] Payment integration
- [ ] Vendor ratings & reviews
- [ ] Advanced search & filters
- [ ] Calendar integration
- [ ] Photo/video upload
- [ ] Contract management
- [ ] Multi-vendor events
- [ ] Analytics dashboard

---

## 📄 License

MIT License - feel free to use this project for learning or commercial purposes.

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 👨‍💻 Developer

**Niraj Kafle**
- Building production-ready Flutter apps
- Focus on clean architecture and great UX

---

**Made with ❤️ using Flutter**
