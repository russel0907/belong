import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ItemStatus { lost, found, reunited }

enum ItemCategory {
  electronics('Electronics', Icons.phone_android),
  documents('Documents', Icons.description),
  keys('Keys', Icons.vpn_key),
  bags('Bags & Luggage', Icons.backpack),
  clothing('Clothing', Icons.checkroom),
  accessories('Accessories', Icons.watch),
  pets('Pets', Icons.pets),
  other('Other', Icons.category);

  final String label;
  final IconData icon;
  const ItemCategory(this.label, this.icon);
}

class BelongUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String initials;
  final int itemsReported;
  final int itemsReunited;
  final int peopleHelped;

  const BelongUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.initials,
    this.itemsReported = 0,
    this.itemsReunited = 0,
    this.peopleHelped = 0,
  });
}

class LostFoundItem {
  final String id;
  final String title;
  final String description;
  final ItemStatus status;
  final ItemCategory category;
  final String location;
  final DateTime date;
  final String? imageUrl;
  final BelongUser reporter;
  final bool isUrgent;
  final double? latitude;
  final double? longitude;

  const LostFoundItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.location,
    required this.date,
    this.imageUrl,
    required this.reporter,
    this.isUrgent = false,
    this.latitude,
    this.longitude,
  });

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(date);
  }

  String get formattedDate => DateFormat('MMM d, yyyy').format(date);
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final bool isRead;
  final IconData icon;
  final Color iconColor;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    this.isRead = false,
    required this.icon,
    required this.iconColor,
  });
}

// Mock Users
final mockUsers = [
  const BelongUser(
    id: 'u1',
    name: 'Alex Morgan',
    email: 'alex@example.com',
    initials: 'AM',
    itemsReported: 12,
    itemsReunited: 8,
    peopleHelped: 15,
  ),
  const BelongUser(
    id: 'u2',
    name: 'Sarah Chen',
    email: 'sarah@example.com',
    initials: 'SC',
    itemsReported: 5,
    itemsReunited: 3,
    peopleHelped: 7,
  ),
  const BelongUser(
    id: 'u3',
    name: 'Marcus Johnson',
    email: 'marcus@example.com',
    initials: 'MJ',
    itemsReported: 8,
    itemsReunited: 6,
    peopleHelped: 10,
  ),
  const BelongUser(
    id: 'u4',
    name: 'Emily Davis',
    email: 'emily@example.com',
    initials: 'ED',
    itemsReported: 3,
    itemsReunited: 2,
    peopleHelped: 4,
  ),
  const BelongUser(
    id: 'u5',
    name: 'James Wilson',
    email: 'james@example.com',
    initials: 'JW',
    itemsReported: 15,
    itemsReunited: 11,
    peopleHelped: 20,
  ),
];

// Mock Items
final mockItems = [
  LostFoundItem(
    id: 'i1',
    title: 'Silver MacBook Pro',
    description:
        'Lost my 14-inch MacBook Pro in a silver case near the Central Park bench area. It has a small sticker of a mountain on the lid. Really need it back for work!',
    status: ItemStatus.lost,
    category: ItemCategory.electronics,
    location: 'Central Park, NY',
    date: DateTime.now().subtract(const Duration(hours: 3)),
    reporter: mockUsers[0],
    isUrgent: true,
    latitude: 40.7829,
    longitude: -73.9654,
  ),
  LostFoundItem(
    id: 'i2',
    title: 'Brown Leather Wallet',
    description:
        'Found a brown leather wallet near the coffee shop on 5th Avenue. Contains some cards and cash. Let me know if this is yours!',
    status: ItemStatus.found,
    category: ItemCategory.accessories,
    location: '5th Avenue Coffee, NY',
    date: DateTime.now().subtract(const Duration(hours: 5)),
    reporter: mockUsers[1],
    latitude: 40.7549,
    longitude: -73.9840,
  ),
  LostFoundItem(
    id: 'i3',
    title: 'House Keys with Blue Keychain',
    description:
        'Lost a set of house keys with a distinctive blue whale keychain. Lost them somewhere between the subway station and home.',
    status: ItemStatus.lost,
    category: ItemCategory.keys,
    location: 'Brooklyn Bridge Station',
    date: DateTime.now().subtract(const Duration(days: 1)),
    reporter: mockUsers[2],
    isUrgent: true,
    latitude: 40.7061,
    longitude: -73.9969,
  ),
  LostFoundItem(
    id: 'i4',
    title: 'Black Tote Bag',
    description:
        'Found a black tote bag left on the subway. Contains a book and some notebooks. Turned it in to the station office.',
    status: ItemStatus.found,
    category: ItemCategory.bags,
    location: 'Times Square Station',
    date: DateTime.now().subtract(const Duration(hours: 8)),
    reporter: mockUsers[3],
    latitude: 40.7580,
    longitude: -73.9855,
  ),
  LostFoundItem(
    id: 'i5',
    title: 'Golden Retriever - Max',
    description:
        'Found a friendly golden retriever near the park. He has a red collar but no tags. Very well-behaved and seems lost.',
    status: ItemStatus.found,
    category: ItemCategory.pets,
    location: 'Prospect Park, Brooklyn',
    date: DateTime.now().subtract(const Duration(hours: 2)),
    reporter: mockUsers[4],
    isUrgent: true,
    latitude: 40.6602,
    longitude: -73.9690,
  ),
  LostFoundItem(
    id: 'i6',
    title: 'iPhone 15 Pro - Space Black',
    description:
        'Lost my iPhone 15 Pro in Space Black. Last seen near the restaurant district. Has a clear case with a pop socket.',
    status: ItemStatus.lost,
    category: ItemCategory.electronics,
    location: 'Downtown Restaurant District',
    date: DateTime.now().subtract(const Duration(hours: 4)),
    reporter: mockUsers[1],
    isUrgent: true,
    latitude: 40.7128,
    longitude: -74.0060,
  ),
  LostFoundItem(
    id: 'i7',
    title: 'Vintage Polaroid Camera',
    description:
        'Found a vintage Polaroid camera on a park bench. Seems to be in working condition. Would love to return it to its owner!',
    status: ItemStatus.found,
    category: ItemCategory.electronics,
    location: 'Washington Square Park',
    date: DateTime.now().subtract(const Duration(days: 2)),
    reporter: mockUsers[0],
    latitude: 40.7308,
    longitude: -73.9973,
  ),
  LostFoundItem(
    id: 'i8',
    title: 'University ID Card',
    description:
        'Lost my NYU student ID card. Name on it is Alex Morgan. Really need it for exams next week!',
    status: ItemStatus.lost,
    category: ItemCategory.documents,
    location: 'NYU Campus Area',
    date: DateTime.now().subtract(const Duration(days: 3)),
    reporter: mockUsers[0],
    latitude: 40.7295,
    longitude: -73.9965,
  ),
  LostFoundItem(
    id: 'i9',
    title: 'Blue Winter Scarf',
    description:
        'Found a soft blue wool scarf hanging on a tree branch. Looks hand-knitted. Left it at the park office.',
    status: ItemStatus.found,
    category: ItemCategory.clothing,
    location: 'Central Park, NY',
    date: DateTime.now().subtract(const Duration(hours: 6)),
    reporter: mockUsers[2],
    latitude: 40.7829,
    longitude: -73.9654,
  ),
  LostFoundItem(
    id: 'i10',
    title: 'AirPods Pro Case',
    description:
        'Found AirPods Pro charging case near the gym entrance. No AirPods inside, just the case.',
    status: ItemStatus.found,
    category: ItemCategory.electronics,
    location: 'Fitness First Gym',
    date: DateTime.now().subtract(const Duration(days: 1)),
    reporter: mockUsers[3],
    latitude: 40.7489,
    longitude: -73.9680,
  ),
  LostFoundItem(
    id: 'i11',
    title: 'Silver Ring with Engraving',
    description:
        'Lost a family heirloom silver ring with an engraving inside. Has immense sentimental value. Reward offered!',
    status: ItemStatus.lost,
    category: ItemCategory.accessories,
    location: 'Beach Boardwalk, Coney Island',
    date: DateTime.now().subtract(const Duration(days: 5)),
    reporter: mockUsers[4],
    isUrgent: true,
    latitude: 40.5749,
    longitude: -73.9850,
  ),
  LostFoundItem(
    id: 'i12',
    title: 'Textbook - Organic Chemistry',
    description:
        'Found a heavy organic chemistry textbook in the library. Has notes inside. Probably belongs to a med student.',
    status: ItemStatus.found,
    category: ItemCategory.documents,
    location: 'City Library, Main Branch',
    date: DateTime.now().subtract(const Duration(hours: 12)),
    reporter: mockUsers[1],
    latitude: 40.7532,
    longitude: -73.9822,
  ),
];

// Mock Notifications
final mockNotifications = [
  NotificationItem(
    id: 'n1',
    title: 'Potential Match Found! 🎉',
    body:
        'The brown leather wallet found on 5th Avenue matches your lost item description.',
    timeAgo: '2m ago',
    icon: Icons.favorite,
    iconColor: const Color(0xFFE11D48),
  ),
  NotificationItem(
    id: 'n2',
    title: 'Someone Found Your Keys!',
    body:
        'A set of keys with a blue keychain was reported near Brooklyn Bridge Station.',
    timeAgo: '1h ago',
    icon: Icons.vpn_key,
    iconColor: const Color(0xFF0D9488),
  ),
  NotificationItem(
    id: 'n3',
    title: 'Item Reunited!',
    body:
        'Sarah Chen confirmed the Polaroid camera has been returned to its owner. 🎊',
    timeAgo: '3h ago',
    isRead: true,
    icon: Icons.celebration,
    iconColor: const Color(0xFF059669),
  ),
  NotificationItem(
    id: 'n4',
    title: 'New Item in Your Area',
    body:
        'A blue winter scarf was found in Central Park, near your saved location.',
    timeAgo: '5h ago',
    isRead: true,
    icon: Icons.location_on,
    iconColor: const Color(0xFFD97706),
  ),
  NotificationItem(
    id: 'n5',
    title: 'Welcome to Belong!',
    body:
        'Thanks for joining! Start by reporting a lost or found item, or browse the community.',
    timeAgo: '1d ago',
    isRead: true,
    icon: Icons.waving_hand,
    iconColor: const Color(0xFF0D9488),
  ),
];

// Helper getters
List<LostFoundItem> get lostItems =>
    mockItems.where((item) => item.status == ItemStatus.lost).toList();

List<LostFoundItem> get foundItems =>
    mockItems.where((item) => item.status == ItemStatus.found).toList();

List<LostFoundItem> get recentItems =>
    List.from(mockItems)..sort((a, b) => b.date.compareTo(a.date));

List<LostFoundItem> get urgentItems =>
    mockItems.where((item) => item.isUrgent).toList();
