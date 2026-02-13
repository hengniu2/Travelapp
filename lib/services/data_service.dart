import '../models/companion.dart';
import '../models/tour.dart';
import '../models/hotel.dart';
import '../models/ticket.dart';
import '../models/insurance.dart';
import '../models/content.dart';
import '../models/content_comment.dart';
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
        bioZh: '5年以上经验丰富的旅行向导',
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
        bioZh: '亚洲目的地本地专家',
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
        bioZh: '城市探索与文化爱好者',
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
        titleZh: '欧洲经典之旅',
        description: 'Explore the best of Europe in 14 days',
        descriptionZh: '14天畅游欧洲精华',
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
        titleZh: '亚洲探险之旅',
        description: 'Discover Southeast Asia',
        descriptionZh: '探索东南亚',
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
        titleZh: '地中海邮轮之旅',
        description: 'Luxury cruise through Mediterranean',
        descriptionZh: '地中海豪华邮轮之旅',
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
        nameZh: '格兰德广场酒店',
        location: 'Paris, France',
        locationZh: '法国巴黎',
        pricePerNight: 250.0,
        rating: 4.5,
        reviewCount: 892,
        amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant'],
        amenitiesZh: ['WiFi', '泳池', '水疗', '餐厅'],
        description: 'Luxury hotel in the heart of Paris',
      ),
      Hotel(
        id: '2',
        name: 'Tokyo Central Inn',
        nameZh: '东京中心旅馆',
        location: 'Tokyo, Japan',
        locationZh: '日本东京',
        pricePerNight: 180.0,
        rating: 4.7,
        reviewCount: 654,
        amenities: ['WiFi', 'Gym', 'Restaurant'],
        amenitiesZh: ['WiFi', '健身房', '餐厅'],
        description: 'Modern hotel near city center',
      ),
      Hotel(
        id: '3',
        name: 'Beach Resort',
        nameZh: '海滨度假村',
        location: 'Bali, Indonesia',
        locationZh: '印度尼西亚巴厘岛',
        pricePerNight: 320.0,
        rating: 4.8,
        reviewCount: 1234,
        amenities: ['WiFi', 'Pool', 'Beach Access', 'Spa', 'Restaurant'],
        amenitiesZh: ['WiFi', '泳池', '海滩', '水疗', '餐厅'],
        description: 'Beachfront resort with stunning views',
      ),
    ];
  }

  List<Ticket> getTickets() {
    return [
      Ticket(
        id: '1',
        name: 'Eiffel Tower Entry',
        nameZh: '埃菲尔铁塔门票',
        location: 'Paris, France',
        locationZh: '法国巴黎',
        price: 29.0,
        type: 'Attraction',
        typeZh: '景点',
        description: 'Skip-the-line ticket to Eiffel Tower',
      ),
      Ticket(
        id: '2',
        name: 'Louvre Museum Pass',
        nameZh: '卢浮宫通票',
        location: 'Paris, France',
        locationZh: '法国巴黎',
        price: 17.0,
        type: 'Museum',
        typeZh: '博物馆',
        description: 'Full access to Louvre Museum',
      ),
      Ticket(
        id: '3',
        name: 'Tokyo Skytree',
        nameZh: '东京晴空塔',
        location: 'Tokyo, Japan',
        locationZh: '日本东京',
        price: 18.0,
        type: 'Attraction',
        typeZh: '景点',
        description: 'Observation deck ticket',
      ),
    ];
  }

  List<Insurance> getInsurancePlans() {
    return [
      Insurance(
        id: '1',
        name: 'Basic Travel Insurance',
        nameZh: '基础旅行保险',
        type: 'Medical',
        typeZh: '医疗',
        price: 49.0,
        coverage: 'Medical expenses up to \$100,000',
        coverageZh: '医疗费用最高 10 万美元',
        duration: 30,
        benefits: ['Medical Coverage', 'Trip Cancellation', 'Baggage Loss'],
        benefitsZh: ['医疗保障', '行程取消', '行李丢失'],
      ),
      Insurance(
        id: '2',
        name: 'Premium Travel Insurance',
        nameZh: '高端旅行保险',
        type: 'Comprehensive',
        typeZh: '综合',
        price: 99.0,
        coverage: 'Full coverage up to \$500,000',
        coverageZh: '全面保障最高 50 万美元',
        duration: 30,
        benefits: ['Medical Coverage', 'Trip Cancellation', 'Baggage Loss', 'Flight Delay', 'Emergency Evacuation'],
        benefitsZh: ['医疗保障', '行程取消', '行李丢失', '航班延误', '紧急撤离'],
      ),
      Insurance(
        id: '3',
        name: 'Adventure Travel Insurance',
        nameZh: '探险旅行保险',
        type: 'Adventure',
        typeZh: '探险',
        price: 149.0,
        coverage: 'Adventure activities coverage',
        coverageZh: '探险活动保障',
        duration: 30,
        benefits: ['Extreme Sports', 'Medical Coverage', 'Equipment Loss', 'Rescue Coverage'],
        benefitsZh: ['极限运动', '医疗保障', '装备损失', '救援保障'],
      ),
    ];
  }

  List<TravelContent> getTravelContent() {
    return [
      TravelContent(
        id: '1',
        title: 'Top 10 Destinations in 2024',
        titleZh: '2024年十大必去目的地',
        content: 'From tropical beaches to historic cities, this year\'s list has something for every traveler.\n\n'
            'We\'ve combined expert picks with trending spots to bring you the best places to explore in 2024.\n\n'
            'Whether you prefer adventure or relaxation, these destinations offer unforgettable experiences.',
        contentZh: '从热带海滩到历史名城，今年的榜单为每位旅行者都准备了精彩选择。\n\n'
            '我们结合专家推荐与热门趋势，为你精选2024年最值得探索的目的地。\n\n'
            '无论你喜欢冒险还是放松，这些地方都能带来难忘的体验。',
        type: 'Guide',
        author: 'Travel Expert',
        authorZh: '旅行专家',
        publishDate: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['Destinations', '2024', 'Travel Tips'],
        views: 15234,
        likes: 892,
      ),
      TravelContent(
        id: '2',
        title: 'Budget Travel Tips',
        titleZh: '穷游省钱攻略',
        content: 'How to travel on a budget without compromising experience...',
        contentZh: '如何在不牺牲体验的前提下省钱旅行……',
        type: 'Tips',
        author: 'Budget Traveler',
        authorZh: '穷游达人',
        publishDate: DateTime.now().subtract(const Duration(days: 10)),
        tags: ['Budget', 'Tips', 'Saving'],
        views: 9876,
        likes: 543,
      ),
      TravelContent(
        id: '3',
        title: 'My Journey Through Japan',
        titleZh: '我的日本之旅',
        content: 'Three weeks across Tokyo, Kyoto, and Osaka gave me a deep appreciation for Japanese culture and cuisine.\n\n'
            'Temples, cherry blossoms, and bullet trains made every day feel like a new chapter.\n\n'
            'I\'ve gathered my best tips and photos to help you plan your own adventure.',
        contentZh: '在东京、京都和大阪的三周让我深深爱上了日本的文化与美食。\n\n'
            '神社、樱花与新干线让每一天都像崭新的一页。\n\n'
            '我整理了实用建议与照片，助你规划自己的日本之行。',
        type: 'Travel Notes',
        author: 'John Doe',
        authorZh: '约翰',
        publishDate: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['Japan', 'Personal', 'Adventure'],
        views: 5432,
        likes: 321,
      ),
      TravelContent(
        id: '4',
        title: 'Hidden Gems in Southeast Asia',
        titleZh: '东南亚小众秘境',
        content: 'Off-the-beaten-path spots in Thailand, Vietnam, and beyond...',
        contentZh: '泰国、越南等地的小众旅行地……',
        type: 'Guide',
        author: 'Local Guide',
        authorZh: '当地向导',
        publishDate: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['Southeast Asia', 'Hidden Gems'],
        views: 8234,
        likes: 456,
      ),
      TravelContent(
        id: '5',
        title: 'Solo Travel Safety Guide',
        titleZh: '独自旅行安全指南',
        content: 'Traveling alone can be rewarding when you follow a few key safety practices.\n\n'
            'From choosing accommodations to staying connected, we cover everything you need for a worry-free trip.\n\n'
            'Real stories and expert advice to keep you confident on the road.',
        contentZh: '做好几点安全准备，独自旅行会非常充实。\n\n'
            '从住宿选择到保持联络，我们为你整理了一份安心出行指南。\n\n'
            '真实经历与专家建议，让你在路上更从容。',
        type: 'Tips',
        author: 'Safety First',
        authorZh: '安全出行',
        publishDate: DateTime.now().subtract(const Duration(days: 7)),
        tags: ['Solo', 'Safety', 'Tips'],
        views: 11200,
        likes: 678,
      ),
      TravelContent(
        id: '6',
        title: 'Weekend Getaways Near the City',
        titleZh: '城市周边周末短途游',
        content: 'You don\'t need to go far for a refreshing break.\n\n'
            'We\'ve rounded up the best weekend trips within a few hours of major cities.\n\n'
            'Nature, culture, and good food—all within reach.',
        contentZh: '不必远行也能享受一次放松的短假。\n\n'
            '我们整理了距离大城市几小时内的最佳周末目的地。\n\n'
            '自然、文化与美食，触手可及。',
        type: 'Tips',
        author: 'Local Guide',
        authorZh: '本地向导',
        publishDate: DateTime.now().subtract(const Duration(days: 4)),
        tags: ['Weekend', 'Short Trip'],
        views: 6780,
        likes: 412,
      ),
      TravelContent(
        id: '7',
        title: 'Food and Street Markets Guide',
        titleZh: '美食与市集攻略',
        content: 'The best travel experiences often happen at the table—or at a market stall.\n\n'
            'Discover where to find authentic flavors and how to eat like a local.\n\n'
            'Maps, opening hours, and must-try dishes included.',
        contentZh: '最好的旅行体验往往发生在餐桌或市集摊前。\n\n'
            '带你找到地道风味，像当地人一样吃。\n\n'
            '附地图、营业时间与必吃清单。',
        type: 'Guide',
        author: 'Food Explorer',
        authorZh: '美食探索',
        publishDate: DateTime.now().subtract(const Duration(days: 3)),
        tags: ['Food', 'Markets', 'Local'],
        views: 9210,
        likes: 567,
      ),
    ];
  }

  /// 论坛文章评论（标题+正文+评论）
  List<ContentComment> getContentComments(String contentId) {
    final comments = <ContentComment>[];
    switch (contentId) {
      case '1':
        comments.addAll([
          ContentComment(
            id: 'c1-1',
            contentId: '1',
            authorName: 'Travel Lover',
            authorNameZh: '旅行爱好者',
            body: 'Great list! I\'ve been to 3 of these.',
            bodyZh: '很棒的榜单！我去过其中3个。',
            date: DateTime.now().subtract(const Duration(days: 2)),
          ),
          ContentComment(
            id: 'c1-2',
            contentId: '1',
            authorName: 'Wanderer',
            authorNameZh: '漫游者',
            body: 'Thanks for sharing. Adding to my bucket list.',
            bodyZh: '感谢分享，已加入我的清单。',
            date: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ]);
        break;
      case '2':
        comments.addAll([
          ContentComment(
            id: 'c2-1',
            contentId: '2',
            authorName: 'Budget Fan',
            authorNameZh: '穷游粉',
            body: 'Very practical tips!',
            bodyZh: '非常实用的建议！',
            date: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ]);
        break;
      case '3':
      case '4':
      case '5':
        comments.addAll([
          ContentComment(
            id: 'c-$contentId-1',
            contentId: contentId,
            authorName: 'Reader',
            authorNameZh: '读者',
            body: 'Good read.',
            bodyZh: '写得不错。',
            date: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ]);
        break;
    }
    return comments;
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

  /// Rich reviews for tour detail (more content, varied ratings).
  List<Review> getReviewsForTour(String tourId) {
    final base = getReviews(tourId, 'tour');
    final extra = [
      Review(
        id: 't3',
        userId: 'u3',
        userName: 'Maria García',
        itemId: tourId,
        itemType: 'tour',
        rating: 5.0,
        comment: 'The itinerary was perfect. Our guide was knowledgeable and the hotels were great. Worth every penny!',
        date: DateTime.now().subtract(const Duration(days: 14)),
      ),
      Review(
        id: 't4',
        userId: 'u4',
        userName: 'James Lee',
        itemId: tourId,
        itemType: 'tour',
        rating: 4.0,
        comment: 'Good value. Some days were a bit rushed but overall a memorable trip.',
        date: DateTime.now().subtract(const Duration(days: 21)),
      ),
      Review(
        id: 't5',
        userId: 'u5',
        userName: 'Sophie Martin',
        itemId: tourId,
        itemType: 'tour',
        rating: 4.8,
        comment: 'Beautiful destinations and well organized. Would recommend to friends.',
        date: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
    return [...base, ...extra];
  }

  /// Similar tours (exclude current, same or different routes).
  List<Tour> getSimilarTours(String excludeTourId, {int limit = 4}) {
    final all = getTours();
    return all.where((t) => t.id != excludeTourId).take(limit).toList();
  }
}



