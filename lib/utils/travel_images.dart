import 'package:flutter/material.dart';

/// Travel-related image URLs from Unsplash
/// These are high-quality, beautiful travel images
class TravelImages {
  // Tour/Destination images
  static const List<String> tourImages = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop', // Mountain landscape
    'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&h=600&fit=crop', // Travel van
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop', // Beach paradise
    'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800&h=600&fit=crop', // City skyline
    'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&h=600&fit=crop', // Mountain lake
    'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800&h=600&fit=crop', // Desert landscape
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop', // Forest trail
    'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800&h=600&fit=crop', // Tropical beach
  ];

  // Companion/Avatar images
  static const List<String> companionAvatars = [
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop', // Person 1
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop', // Person 2
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop', // Person 3
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop', // Person 4
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop', // Person 5
  ];

  // Content/Blog images
  static const List<String> contentImages = [
    'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&h=600&fit=crop', // Travel blog
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800&h=600&fit=crop', // Adventure
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800&h=600&fit=crop', // Nature
    'https://images.unsplash.com/photo-1501785888041-af3ef7b1a2ce?w=800&h=600&fit=crop', // Landscape
    'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&h=600&fit=crop', // Mountain
  ];

  // Hotel images
  static const List<String> hotelImages = [
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=600&fit=crop', // Luxury hotel
    'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&h=600&fit=crop', // Resort
    'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800&h=600&fit=crop', // Beach resort
    'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&h=600&fit=crop', // Hotel room
  ];

  // Get a random tour image
  static String getTourImage(int index) {
    return tourImages[index % tourImages.length];
  }

  // Get a random companion avatar
  static String getCompanionAvatar(int index) {
    return companionAvatars[index % companionAvatars.length];
  }

  // Get a random content image
  static String getContentImage(int index) {
    return contentImages[index % contentImages.length];
  }

  // Get a random hotel image
  static String getHotelImage(int index) {
    return hotelImages[index % hotelImages.length];
  }

  // Beautiful gradient backgrounds for placeholders
  static List<Color> getGradientForIndex(int index) {
    final gradients = [
      [const Color(0xFF00C853), const Color(0xFF00A844)], // Green
      [const Color(0xFFFF6B35), const Color(0xFFF7931E)], // Orange
      [const Color(0xFF2979FF), const Color(0xFF00E5FF)], // Blue
      [const Color(0xFFAA00FF), const Color(0xFFFF4081)], // Purple
      [const Color(0xFFFF1744), const Color(0xFFFF6B6B)], // Red
      [const Color(0xFFFFD600), const Color(0xFFFFB74D)], // Yellow
    ];
    return gradients[index % gradients.length];
  }
}


