import '../models/companion.dart';
import '../models/tour.dart';
import '../models/hotel.dart';
import '../models/ticket.dart';
import '../models/insurance.dart';
import '../models/content.dart';
import '../models/review.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Companion> getCompanions() {
    return [
      Companion(
        id: '1',
        name: 'Sarah Johnson',
        destinations: ['Paris', 'Rome', 'Barcelona'],
        interests: ['History', 'Art', 'Food'],
        skills: ['Photography', 'French', 'Guiding'],
        rating: 4.8,
        reviewCount: 127,
        bio: 'Experienced travel guide with 5+ years',
        pricePerDay: 150.0,
        isAvailable: true,
        languages: ['English', 'French', 'Spanish'],
      ),
      Companion(
        id: '2',
        name: 'Michael Chen',
        destinations: ['Tokyo', 'Seoul', 'Bangkok'],
        interests: ['Culture', 'Food', 'Technology'],
        skills: ['Japanese', 'Photography', 'Planning'],
        rating: 4.9,
        reviewCount: 203,
        bio: 'Local expert in Asian destinations',
        pricePerDay: 180.0,
        isAvailable: true,
        languages: ['English', 'Japanese', 'Mandarin'],
      ),
      Companion(
        id: '3',
        name: 'Emma Wilson',
        destinations: ['New York', 'London', 'Amsterdam'],
        interests: ['Architecture', 'Museums', 'Nightlife'],
        skills: ['Planning', 'Photography', 'English'],
        rating: 4.7,
        reviewCount: 89,
        bio: 'Urban explorer and culture enthusiast',
        pricePerDay: 140.0,
        isAvailable: false,
        languages: ['English', 'Dutch'],
      ),
    ];
  }

  List<Tour> getTours() {
    return [
      Tour(
        id: '1',
        title: 'European Grand Tour',
        description: 'Explore the best of Europe in 14 days',
        route: ['Paris', 'Brussels', 'Amsterdam', 'Berlin', 'Prague'],
        routeType: 'Multi-City',
        price: 2999.0,
        duration: 14,
        rating: 4.8,
        reviewCount: 342,
        maxParticipants: 20,
        startDate: DateTime.now().add(const Duration(days: 30)),
        isTrending: true,
      ),
      Tour(
        id: '2',
        title: 'Asian Adventure',
        description: 'Discover Southeast Asia',
        route: ['Bangkok', 'Singapore', 'Kuala Lumpur'],
        routeType: 'City Tour',
        price: 1899.0,
        duration: 10,
        rating: 4.6,
        reviewCount: 198,
        maxParticipants: 15,
        startDate: DateTime.now().add(const Duration(days: 45)),
        isTrending: true,
      ),
      Tour(
        id: '3',
        title: 'Mediterranean Cruise',
        description: 'Luxury cruise through Mediterranean',
        route: ['Barcelona', 'Monaco', 'Rome', 'Athens'],
        routeType: 'Cruise',
        price: 4499.0,
        duration: 7,
        rating: 4.9,
        reviewCount: 156,
        maxParticipants: 50,
        startDate: DateTime.now().add(const Duration(days: 60)),
      ),
    ];
  }

  List<Hotel> getHotels() {
    return [
      Hotel(
        id: '1',
        name: 'Grand Plaza Hotel',
        location: 'Paris, France',
        pricePerNight: 250.0,
        rating: 4.5,
        reviewCount: 892,
        amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant'],
        description: 'Luxury hotel in the heart of Paris',
      ),
      Hotel(
        id: '2',
        name: 'Tokyo Central Inn',
        location: 'Tokyo, Japan',
        pricePerNight: 180.0,
        rating: 4.7,
        reviewCount: 654,
        amenities: ['WiFi', 'Gym', 'Restaurant'],
        description: 'Modern hotel near city center',
      ),
      Hotel(
        id: '3',
        name: 'Beach Resort',
        location: 'Bali, Indonesia',
        pricePerNight: 320.0,
        rating: 4.8,
        reviewCount: 1234,
        amenities: ['WiFi', 'Pool', 'Beach Access', 'Spa', 'Restaurant'],
        description: 'Beachfront resort with stunning views',
      ),
    ];
  }

  List<Ticket> getTickets() {
    return [
      Ticket(
        id: '1',
        name: 'Eiffel Tower Entry',
        location: 'Paris, France',
        price: 29.0,
        type: 'Attraction',
        description: 'Skip-the-line ticket to Eiffel Tower',
      ),
      Ticket(
        id: '2',
        name: 'Louvre Museum Pass',
        location: 'Paris, France',
        price: 17.0,
        type: 'Museum',
        description: 'Full access to Louvre Museum',
      ),
      Ticket(
        id: '3',
        name: 'Tokyo Skytree',
        location: 'Tokyo, Japan',
        price: 18.0,
        type: 'Attraction',
        description: 'Observation deck ticket',
      ),
    ];
  }

  List<Insurance> getInsurancePlans() {
    return [
      Insurance(
        id: '1',
        name: 'Basic Travel Insurance',
        type: 'Medical',
        price: 49.0,
        coverage: 'Medical expenses up to \$100,000',
        duration: 30,
        benefits: ['Medical Coverage', 'Trip Cancellation', 'Baggage Loss'],
      ),
      Insurance(
        id: '2',
        name: 'Premium Travel Insurance',
        type: 'Comprehensive',
        price: 99.0,
        coverage: 'Full coverage up to \$500,000',
        duration: 30,
        benefits: ['Medical Coverage', 'Trip Cancellation', 'Baggage Loss', 'Flight Delay', 'Emergency Evacuation'],
      ),
      Insurance(
        id: '3',
        name: 'Adventure Travel Insurance',
        type: 'Adventure',
        price: 149.0,
        coverage: 'Adventure activities coverage',
        duration: 30,
        benefits: ['Extreme Sports', 'Medical Coverage', 'Equipment Loss', 'Rescue Coverage'],
      ),
    ];
  }

  List<TravelContent> getTravelContent() {
    return [
      TravelContent(
        id: '1',
        title: 'Top 10 Destinations in 2024',
        content: 'Discover the most beautiful places to visit this year...',
        type: 'Guide',
        author: 'Travel Expert',
        publishDate: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['Destinations', '2024', 'Travel Tips'],
        views: 15234,
        likes: 892,
      ),
      TravelContent(
        id: '2',
        title: 'Budget Travel Tips',
        content: 'How to travel on a budget without compromising experience...',
        type: 'Tips',
        author: 'Budget Traveler',
        publishDate: DateTime.now().subtract(const Duration(days: 10)),
        tags: ['Budget', 'Tips', 'Saving'],
        views: 9876,
        likes: 543,
      ),
      TravelContent(
        id: '3',
        title: 'My Journey Through Japan',
        content: 'A personal travelogue of my 3-week adventure...',
        type: 'Travel Notes',
        author: 'John Doe',
        publishDate: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['Japan', 'Personal', 'Adventure'],
        views: 5432,
        likes: 321,
      ),
    ];
  }

  List<Review> getReviews(String itemId, String itemType) {
    return [
      Review(
        id: '1',
        userId: 'u1',
        userName: 'Alice Smith',
        itemId: itemId,
        itemType: itemType,
        rating: 5.0,
        comment: 'Excellent experience! Highly recommended.',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Review(
        id: '2',
        userId: 'u2',
        userName: 'Bob Johnson',
        itemId: itemId,
        itemType: itemType,
        rating: 4.5,
        comment: 'Great service, would book again.',
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}



