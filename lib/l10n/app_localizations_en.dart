// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Travel App';

  @override
  String get home => 'Home';

  @override
  String get companions => 'Companions';

  @override
  String get tours => 'Tours';

  @override
  String get bookings => 'Bookings';

  @override
  String get content => 'Content';

  @override
  String get profile => 'Profile';

  @override
  String get travelCompanions => 'Travel Companions';

  @override
  String get tourGroups => 'Tour Groups';

  @override
  String get travelContent => 'Travel Content';

  @override
  String get noCompanionsFound => 'No companions found';

  @override
  String get noToursFound => 'No tours found';

  @override
  String get noHotelsFound => 'No hotels found';

  @override
  String get noContentFound => 'No content found';

  @override
  String get companionDetails => 'Companion Details';

  @override
  String get tourDetails => 'Tour Details';

  @override
  String get hotelDetails => 'Hotel Details';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get pricePerDay => 'Price per day';

  @override
  String get destinations => 'Destinations';

  @override
  String get interests => 'Interests';

  @override
  String get skills => 'Skills';

  @override
  String get languages => 'Languages';

  @override
  String get chat => 'Chat';

  @override
  String get bookNow => 'Book Now';

  @override
  String get filter => 'Filter';

  @override
  String get search => 'Search';

  @override
  String get searchHotels => 'Search hotels...';

  @override
  String get sort => 'Sort';

  @override
  String get sortHotels => 'Sort Hotels';

  @override
  String get priceLowToHigh => 'Price: Low to High';

  @override
  String get priceHighToLow => 'Price: High to Low';

  @override
  String get ratingHighToLow => 'Rating: High to Low';

  @override
  String get hotels => 'Hotels';

  @override
  String get tickets => 'Tickets';

  @override
  String get insurance => 'Insurance';

  @override
  String get orders => 'Orders';

  @override
  String get favorites => 'Favorites';

  @override
  String get reviews => 'Reviews';

  @override
  String get wallet => 'Wallet';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get all => 'All';

  @override
  String get guide => 'Guide';

  @override
  String get tips => 'Tips';

  @override
  String get travelNotes => 'Travel Notes';

  @override
  String get trending => 'Trending';

  @override
  String get duration => 'Duration';

  @override
  String days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String maxParticipants(int count) {
    return 'Max $count';
  }

  @override
  String get route => 'Route';

  @override
  String get description => 'Description';

  @override
  String get amenities => 'Amenities';

  @override
  String get location => 'Location';

  @override
  String get rating => 'Rating';

  @override
  String get views => 'Views';

  @override
  String get likes => 'Likes';

  @override
  String get author => 'Author';

  @override
  String get publishDate => 'Publish Date';

  @override
  String get guest => 'Guest';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone number';

  @override
  String get displayName => 'Display name';

  @override
  String get phoneRequired => 'Please enter your phone number';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get name => 'Name';

  @override
  String get loginButton => 'Log in';

  @override
  String get registerButton => 'Create account';

  @override
  String get noAccountRegister => 'Don\'t have an account? Register';

  @override
  String get haveAccountLogin => 'Already have an account? Log in';

  @override
  String get logout => 'Log out';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get registerTitle => 'Create account';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get nameRequired => 'Please enter your name';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get loginFailed => 'Login failed. Check email, phone number and password.';

  @override
  String get registerFailed => 'Registration failed. Please try again.';

  @override
  String get cancel => 'Cancel';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';
}
