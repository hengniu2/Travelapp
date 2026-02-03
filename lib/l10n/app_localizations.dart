import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Travel App'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @companions.
  ///
  /// In en, this message translates to:
  /// **'Companions'**
  String get companions;

  /// No description provided for @tours.
  ///
  /// In en, this message translates to:
  /// **'Tours'**
  String get tours;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @travelCompanions.
  ///
  /// In en, this message translates to:
  /// **'Travel Companions'**
  String get travelCompanions;

  /// No description provided for @tourGroups.
  ///
  /// In en, this message translates to:
  /// **'Tour Groups'**
  String get tourGroups;

  /// No description provided for @travelContent.
  ///
  /// In en, this message translates to:
  /// **'Travel Content'**
  String get travelContent;

  /// No description provided for @noCompanionsFound.
  ///
  /// In en, this message translates to:
  /// **'No companions found'**
  String get noCompanionsFound;

  /// No description provided for @noToursFound.
  ///
  /// In en, this message translates to:
  /// **'No tours found'**
  String get noToursFound;

  /// No description provided for @noHotelsFound.
  ///
  /// In en, this message translates to:
  /// **'No hotels found'**
  String get noHotelsFound;

  /// No description provided for @noContentFound.
  ///
  /// In en, this message translates to:
  /// **'No content found'**
  String get noContentFound;

  /// No description provided for @companionDetails.
  ///
  /// In en, this message translates to:
  /// **'Companion Details'**
  String get companionDetails;

  /// No description provided for @tourDetails.
  ///
  /// In en, this message translates to:
  /// **'Tour Details'**
  String get tourDetails;

  /// No description provided for @hotelDetails.
  ///
  /// In en, this message translates to:
  /// **'Hotel Details'**
  String get hotelDetails;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @pricePerDay.
  ///
  /// In en, this message translates to:
  /// **'Price per day'**
  String get pricePerDay;

  /// No description provided for @destinations.
  ///
  /// In en, this message translates to:
  /// **'Destinations'**
  String get destinations;

  /// No description provided for @interests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interests;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHotels.
  ///
  /// In en, this message translates to:
  /// **'Search hotels...'**
  String get searchHotels;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @sortHotels.
  ///
  /// In en, this message translates to:
  /// **'Sort Hotels'**
  String get sortHotels;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @ratingHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Rating: High to Low'**
  String get ratingHighToLow;

  /// No description provided for @hotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get hotels;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guide;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @travelNotes.
  ///
  /// In en, this message translates to:
  /// **'Travel Notes'**
  String get travelNotes;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Number of days
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day} other{days}}'**
  String days(int count);

  /// Maximum participants
  ///
  /// In en, this message translates to:
  /// **'Max {count}'**
  String maxParticipants(int count);

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @publishDate.
  ///
  /// In en, this message translates to:
  /// **'Publish Date'**
  String get publishDate;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
