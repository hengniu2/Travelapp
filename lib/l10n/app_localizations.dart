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

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore the World'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your next destination'**
  String get homeSubtitle;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @travelGuides.
  ///
  /// In en, this message translates to:
  /// **'Travel Guides'**
  String get travelGuides;

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

  /// No description provided for @contentDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get contentDiscover;

  /// No description provided for @contentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore travel inspiration'**
  String get contentSubtitle;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @latestArticles.
  ///
  /// In en, this message translates to:
  /// **'Latest Articles'**
  String get latestArticles;

  /// No description provided for @searchContentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search content…'**
  String get searchContentPlaceholder;

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

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View more'**
  String get viewMore;

  /// No description provided for @departFrom.
  ///
  /// In en, this message translates to:
  /// **'Depart from'**
  String get departFrom;

  /// No description provided for @destinationKeywords.
  ///
  /// In en, this message translates to:
  /// **'Dest. / Keyword'**
  String get destinationKeywords;

  /// No description provided for @recommend.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get recommend;

  /// No description provided for @topRanking.
  ///
  /// In en, this message translates to:
  /// **'Top ranking'**
  String get topRanking;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Number of days
  ///
  /// In en, this message translates to:
  /// **'Days'**
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

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerButton;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get noAccountRegister;

  /// No description provided for @haveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get haveAccountLogin;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Check email, phone number and password.'**
  String get loginFailed;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registerFailed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @myReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get myReviews;

  /// No description provided for @attractionTickets.
  ///
  /// In en, this message translates to:
  /// **'Attraction Tickets'**
  String get attractionTickets;

  /// No description provided for @travelInsurance.
  ///
  /// In en, this message translates to:
  /// **'Travel Insurance'**
  String get travelInsurance;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @filterTours.
  ///
  /// In en, this message translates to:
  /// **'Filter Tours'**
  String get filterTours;

  /// No description provided for @filterCompanions.
  ///
  /// In en, this message translates to:
  /// **'Filter Companions'**
  String get filterCompanions;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select payment method:'**
  String get selectPaymentMethod;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @tourBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your tour booking has been confirmed.'**
  String get tourBookingConfirmed;

  /// No description provided for @hotelBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your hotel booking has been confirmed.'**
  String get hotelBookingConfirmed;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @bookTour.
  ///
  /// In en, this message translates to:
  /// **'Book Tour'**
  String get bookTour;

  /// No description provided for @bookHotel.
  ///
  /// In en, this message translates to:
  /// **'Book Hotel'**
  String get bookHotel;

  /// No description provided for @bookCompanion.
  ///
  /// In en, this message translates to:
  /// **'Book Companion'**
  String get bookCompanion;

  /// No description provided for @proceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedToPayment;

  /// No description provided for @pleaseSelectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Please select start date first'**
  String get pleaseSelectStartDate;

  /// No description provided for @pleaseSelectDates.
  ///
  /// In en, this message translates to:
  /// **'Please select dates'**
  String get pleaseSelectDates;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @nights.
  ///
  /// In en, this message translates to:
  /// **'Nights'**
  String get nights;

  /// No description provided for @eAgreement.
  ///
  /// In en, this message translates to:
  /// **'E-Agreement'**
  String get eAgreement;

  /// No description provided for @agreeAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Agree & Confirm'**
  String get agreeAndConfirm;

  /// No description provided for @insurancePurchasedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Insurance purchased successfully!'**
  String get insurancePurchasedSuccess;

  /// No description provided for @ticketBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ticket booked successfully!'**
  String get ticketBookedSuccess;

  /// No description provided for @addedToWallet.
  ///
  /// In en, this message translates to:
  /// **'Added to wallet'**
  String get addedToWallet;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @referencePrice.
  ///
  /// In en, this message translates to:
  /// **'Reference price'**
  String get referencePrice;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @priceFrom.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get priceFrom;

  /// No description provided for @favoritesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on tours, companions or hotels to add them here.'**
  String get favoritesEmptySubtitle;

  /// No description provided for @ordersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your orders will appear here after booking.'**
  String get ordersEmptySubtitle;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'/day'**
  String get perDay;

  /// No description provided for @perNight.
  ///
  /// In en, this message translates to:
  /// **'/night'**
  String get perNight;

  /// No description provided for @viewOrders.
  ///
  /// In en, this message translates to:
  /// **'View orders'**
  String get viewOrders;

  /// No description provided for @viewFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get viewFavorites;

  /// No description provided for @promotionsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Promotions coming soon'**
  String get promotionsComingSoon;

  /// No description provided for @contentEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch category above or check back later for new content.'**
  String get contentEmptySubtitle;

  /// No description provided for @hot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get hot;

  /// No description provided for @purePlay.
  ///
  /// In en, this message translates to:
  /// **'Pure play'**
  String get purePlay;

  /// No description provided for @toursEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change filter or sort to discover more tours.'**
  String get toursEmptySubtitle;

  /// No description provided for @tagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsLabel;

  /// No description provided for @bodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get bodyLabel;

  /// No description provided for @wechat.
  ///
  /// In en, this message translates to:
  /// **'WeChat'**
  String get wechat;

  /// No description provided for @weibo.
  ///
  /// In en, this message translates to:
  /// **'Weibo'**
  String get weibo;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @sharedTo.
  ///
  /// In en, this message translates to:
  /// **'Shared to {channel}'**
  String sharedTo(String channel);

  /// No description provided for @itineraryIntro.
  ///
  /// In en, this message translates to:
  /// **'Itinerary'**
  String get itineraryIntro;

  /// No description provided for @itineraryInfo.
  ///
  /// In en, this message translates to:
  /// **'Trip info'**
  String get itineraryInfo;

  /// No description provided for @itineraryRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get itineraryRoute;

  /// No description provided for @itinerarySchedule.
  ///
  /// In en, this message translates to:
  /// **'Day-by-day itinerary'**
  String get itinerarySchedule;

  /// No description provided for @packageDetails.
  ///
  /// In en, this message translates to:
  /// **'Package details'**
  String get packageDetails;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @included.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get included;

  /// No description provided for @notIncluded.
  ///
  /// In en, this message translates to:
  /// **'Not included'**
  String get notIncluded;

  /// No description provided for @dayNumber.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String dayNumber(int number);

  /// No description provided for @departureCity.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departureCity;

  /// No description provided for @notIncludedPersonalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Personal expenses'**
  String get notIncludedPersonalExpenses;

  /// No description provided for @notIncludedTravelInsurance.
  ///
  /// In en, this message translates to:
  /// **'Travel insurance'**
  String get notIncludedTravelInsurance;

  /// No description provided for @activityMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning: Arrival & check-in'**
  String get activityMorning;

  /// No description provided for @activityAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon: Sightseeing'**
  String get activityAfternoon;

  /// No description provided for @importantInfo.
  ///
  /// In en, this message translates to:
  /// **'Important information'**
  String get importantInfo;

  /// No description provided for @whatToBring.
  ///
  /// In en, this message translates to:
  /// **'What to bring'**
  String get whatToBring;

  /// No description provided for @visaInfo.
  ///
  /// In en, this message translates to:
  /// **'Visa & documents'**
  String get visaInfo;

  /// No description provided for @similarTours.
  ///
  /// In en, this message translates to:
  /// **'Similar tours'**
  String get similarTours;

  /// No description provided for @viewAllPhotos.
  ///
  /// In en, this message translates to:
  /// **'View all photos'**
  String get viewAllPhotos;

  /// No description provided for @tourPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get tourPhotos;

  /// No description provided for @seeAllReviews.
  ///
  /// In en, this message translates to:
  /// **'See all reviews'**
  String get seeAllReviews;

  /// No description provided for @travelTips.
  ///
  /// In en, this message translates to:
  /// **'Travel tips'**
  String get travelTips;

  /// No description provided for @bookingNotes.
  ///
  /// In en, this message translates to:
  /// **'Booking notes'**
  String get bookingNotes;

  /// No description provided for @visaInfoDetail.
  ///
  /// In en, this message translates to:
  /// **'Check visa requirements for your nationality. Passport valid 6+ months.'**
  String get visaInfoDetail;

  /// No description provided for @whatToBringDetail.
  ///
  /// In en, this message translates to:
  /// **'Comfortable shoes, weather-appropriate clothing, adapter, medication.'**
  String get whatToBringDetail;

  /// No description provided for @travelTipsDetail.
  ///
  /// In en, this message translates to:
  /// **'Local SIM or roaming recommended. Keep copies of booking confirmations.'**
  String get travelTipsDetail;

  /// No description provided for @mealsIncluded.
  ///
  /// In en, this message translates to:
  /// **'Meals included'**
  String get mealsIncluded;

  /// No description provided for @tourCardNightsHotel.
  ///
  /// In en, this message translates to:
  /// **'Includes {nights} nights hotel'**
  String tourCardNightsHotel(int nights);

  /// No description provided for @tourCardMeals.
  ///
  /// In en, this message translates to:
  /// **'Includes {count} meals'**
  String tourCardMeals(int count);

  /// No description provided for @tourCardGroupGuarantee.
  ///
  /// In en, this message translates to:
  /// **'Group guarantee'**
  String get tourCardGroupGuarantee;

  /// No description provided for @tourCardInstantConfirm.
  ///
  /// In en, this message translates to:
  /// **'Instant confirm'**
  String get tourCardInstantConfirm;

  /// No description provided for @departureFromCity.
  ///
  /// In en, this message translates to:
  /// **'From {city}'**
  String departureFromCity(String city);

  /// No description provided for @selectedItineraries.
  ///
  /// In en, this message translates to:
  /// **'Selected itineraries'**
  String get selectedItineraries;

  /// No description provided for @hotelIntro.
  ///
  /// In en, this message translates to:
  /// **'Hotel overview'**
  String get hotelIntro;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @reviewComment1.
  ///
  /// In en, this message translates to:
  /// **'Excellent experience! Highly recommended.'**
  String get reviewComment1;

  /// No description provided for @reviewComment2.
  ///
  /// In en, this message translates to:
  /// **'Great service, would book again.'**
  String get reviewComment2;

  /// No description provided for @reviewComment3.
  ///
  /// In en, this message translates to:
  /// **'The itinerary was perfect. Our guide was knowledgeable and the hotels were great. Worth every penny!'**
  String get reviewComment3;

  /// No description provided for @reviewComment4.
  ///
  /// In en, this message translates to:
  /// **'Good value. Some days were a bit rushed but overall a memorable trip.'**
  String get reviewComment4;

  /// No description provided for @reviewComment5.
  ///
  /// In en, this message translates to:
  /// **'Beautiful destinations and well organized. Would recommend to friends.'**
  String get reviewComment5;

  /// No description provided for @reviewUserName1.
  ///
  /// In en, this message translates to:
  /// **'Alice Smith'**
  String get reviewUserName1;

  /// No description provided for @reviewUserName2.
  ///
  /// In en, this message translates to:
  /// **'Bob Johnson'**
  String get reviewUserName2;

  /// No description provided for @reviewUserName3.
  ///
  /// In en, this message translates to:
  /// **'Maria García'**
  String get reviewUserName3;

  /// No description provided for @reviewUserName4.
  ///
  /// In en, this message translates to:
  /// **'James Lee'**
  String get reviewUserName4;

  /// No description provided for @reviewUserName5.
  ///
  /// In en, this message translates to:
  /// **'Sophie Martin'**
  String get reviewUserName5;

  /// No description provided for @reviewsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'After completing a trip or service, you can leave a review here.'**
  String get reviewsEmptySubtitle;

  /// No description provided for @tryOtherKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try other keywords or filters to find your ideal hotel.'**
  String get tryOtherKeywords;

  /// No description provided for @specialRequirementsHint.
  ///
  /// In en, this message translates to:
  /// **'Any special requirements or notes...'**
  String get specialRequirementsHint;

  /// No description provided for @searchTickets.
  ///
  /// In en, this message translates to:
  /// **'Search tickets...'**
  String get searchTickets;

  /// No description provided for @eAgreementTerms.
  ///
  /// In en, this message translates to:
  /// **'By proceeding, you agree to the terms and conditions:\n\n• Service agreement and cancellation policy apply.\n• Personal data will be used for booking and support only.'**
  String get eAgreementTerms;

  /// No description provided for @eAgreementConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you agree to these terms?'**
  String get eAgreementConfirm;

  /// No description provided for @selectDates.
  ///
  /// In en, this message translates to:
  /// **'Select Dates'**
  String get selectDates;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify phone'**
  String get verifyPhone;

  /// No description provided for @verificationCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to'**
  String get verificationCodeSentTo;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resendCodeInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend code ({seconds}s)'**
  String resendCodeInSeconds(int seconds);

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeYourProfile;

  /// No description provided for @setDisplayNameToContinue.
  ///
  /// In en, this message translates to:
  /// **'Set a display name to continue.'**
  String get setDisplayNameToContinue;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @avatarUrlOptional.
  ///
  /// In en, this message translates to:
  /// **'Avatar URL (optional)'**
  String get avatarUrlOptional;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed. Please try again.'**
  String get updateFailed;

  /// No description provided for @enter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get enter6DigitCode;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// No description provided for @sendCodeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send code'**
  String get sendCodeFailed;

  /// No description provided for @countryChina.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get countryChina;

  /// No description provided for @countryUSA.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUSA;

  /// No description provided for @countryUK.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryUK;

  /// No description provided for @countryJapan.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get countryJapan;

  /// No description provided for @countryKorea.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get countryKorea;

  /// No description provided for @countrySingapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get countrySingapore;

  /// No description provided for @countryHongKong.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong'**
  String get countryHongKong;

  /// No description provided for @countryTaiwan.
  ///
  /// In en, this message translates to:
  /// **'Taiwan'**
  String get countryTaiwan;

  /// No description provided for @countryAustralia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get countryAustralia;

  /// No description provided for @countryGermany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryGermany;

  /// No description provided for @countryFrance.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFrance;

  /// No description provided for @countryIndia.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIndia;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @ratingPoints.
  ///
  /// In en, this message translates to:
  /// **' pts'**
  String get ratingPoints;

  /// No description provided for @reviewCountWithNumber.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewCountWithNumber(int count);

  /// No description provided for @bookedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} booked'**
  String bookedCount(int count);

  /// No description provided for @discoverCompanions.
  ///
  /// In en, this message translates to:
  /// **'Discover Companions'**
  String get discoverCompanions;

  /// No description provided for @companionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find like-minded travel partners to explore the world together'**
  String get companionSubtitle;

  /// No description provided for @companionsCount.
  ///
  /// In en, this message translates to:
  /// **' companions'**
  String get companionsCount;

  /// No description provided for @highRating.
  ///
  /// In en, this message translates to:
  /// **' high rating'**
  String get highRating;

  /// No description provided for @tryAdjustFilter.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting filters'**
  String get tryAdjustFilter;

  /// No description provided for @local.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @toursTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Tours'**
  String get toursTitle;

  /// No description provided for @toursSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hassle-free · All-in-one travel'**
  String get toursSubtitle;

  /// No description provided for @departShanghai.
  ///
  /// In en, this message translates to:
  /// **'From Shanghai'**
  String get departShanghai;

  /// No description provided for @hotDepartureCities.
  ///
  /// In en, this message translates to:
  /// **'Popular departure cities'**
  String get hotDepartureCities;

  /// No description provided for @featuredRecommend.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featuredRecommend;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all >'**
  String get viewAll;

  /// No description provided for @categoryHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get categoryHot;

  /// No description provided for @categoryIsland.
  ///
  /// In en, this message translates to:
  /// **'Island'**
  String get categoryIsland;

  /// No description provided for @categoryMountain.
  ///
  /// In en, this message translates to:
  /// **'Mountain'**
  String get categoryMountain;

  /// No description provided for @categoryTown.
  ///
  /// In en, this message translates to:
  /// **'Ancient town'**
  String get categoryTown;

  /// No description provided for @categoryCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get categoryCity;

  /// No description provided for @cityXishuangbanna.
  ///
  /// In en, this message translates to:
  /// **'Xishuangbanna'**
  String get cityXishuangbanna;

  /// No description provided for @cityBeijing.
  ///
  /// In en, this message translates to:
  /// **'Beijing'**
  String get cityBeijing;

  /// No description provided for @citySanya.
  ///
  /// In en, this message translates to:
  /// **'Sanya'**
  String get citySanya;

  /// No description provided for @cityLijiang.
  ///
  /// In en, this message translates to:
  /// **'Lijiang'**
  String get cityLijiang;

  /// No description provided for @cityGuilin.
  ///
  /// In en, this message translates to:
  /// **'Guilin'**
  String get cityGuilin;

  /// No description provided for @cityChengdu.
  ///
  /// In en, this message translates to:
  /// **'Chengdu'**
  String get cityChengdu;

  /// No description provided for @cityHarbin.
  ///
  /// In en, this message translates to:
  /// **'Harbin'**
  String get cityHarbin;

  /// No description provided for @cityChongqing.
  ///
  /// In en, this message translates to:
  /// **'Chongqing'**
  String get cityChongqing;

  /// No description provided for @experiencedGuideBio.
  ///
  /// In en, this message translates to:
  /// **'Experienced travel guide with 5+ years'**
  String get experiencedGuideBio;

  /// No description provided for @localExpertBio.
  ///
  /// In en, this message translates to:
  /// **'Local expert in Asian destinations'**
  String get localExpertBio;

  /// No description provided for @urbanExplorerBio.
  ///
  /// In en, this message translates to:
  /// **'Urban explorer and culture enthusiast'**
  String get urbanExplorerBio;

  /// No description provided for @dailyLabel.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get dailyLabel;

  /// No description provided for @routeTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Route type'**
  String get routeTypeLabel;

  /// No description provided for @routeTypeMultiCity.
  ///
  /// In en, this message translates to:
  /// **'Multi-City'**
  String get routeTypeMultiCity;

  /// No description provided for @routeTypeCityTour.
  ///
  /// In en, this message translates to:
  /// **'City Tour'**
  String get routeTypeCityTour;

  /// No description provided for @routeTypeCruise.
  ///
  /// In en, this message translates to:
  /// **'Cruise'**
  String get routeTypeCruise;

  /// No description provided for @itineraryDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get itineraryDuration;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDateLabel;

  /// No description provided for @referencePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference price'**
  String get referencePriceLabel;

  /// No description provided for @maxParticipantsLabel.
  ///
  /// In en, this message translates to:
  /// **'Max participants'**
  String get maxParticipantsLabel;

  /// No description provided for @peopleUnit.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get peopleUnit;

  /// No description provided for @bookingInformation.
  ///
  /// In en, this message translates to:
  /// **'Booking Information'**
  String get bookingInformation;

  /// No description provided for @tourLabel.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get tourLabel;

  /// No description provided for @participantsLabel.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participantsLabel;

  /// No description provided for @totalPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Price:'**
  String get totalPriceLabel;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @coverageLine.
  ///
  /// In en, this message translates to:
  /// **'Coverage: {coverage} · {duration} days'**
  String coverageLine(String coverage, int duration);

  /// No description provided for @bookingCategories.
  ///
  /// In en, this message translates to:
  /// **'Booking categories'**
  String get bookingCategories;

  /// No description provided for @quickBooking.
  ///
  /// In en, this message translates to:
  /// **'Quick booking'**
  String get quickBooking;

  /// No description provided for @mySection.
  ///
  /// In en, this message translates to:
  /// **'My'**
  String get mySection;

  /// No description provided for @bookingService.
  ///
  /// In en, this message translates to:
  /// **'Booking service'**
  String get bookingService;

  /// No description provided for @bookingServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hotels / Tickets / Insurance / Transport'**
  String get bookingServiceSubtitle;

  /// No description provided for @featuredDeals.
  ///
  /// In en, this message translates to:
  /// **'Featured deals'**
  String get featuredDeals;

  /// No description provided for @hotAttractions.
  ///
  /// In en, this message translates to:
  /// **'Hot attractions'**
  String get hotAttractions;

  /// No description provided for @travelProtection.
  ///
  /// In en, this message translates to:
  /// **'Travel protection'**
  String get travelProtection;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @transferAndCar.
  ///
  /// In en, this message translates to:
  /// **'Transfer / Car'**
  String get transferAndCar;

  /// No description provided for @quickItemShanghaiBund.
  ///
  /// In en, this message translates to:
  /// **'Shanghai Bund Hotel'**
  String get quickItemShanghaiBund;

  /// No description provided for @quickItemForbiddenCity.
  ///
  /// In en, this message translates to:
  /// **'Forbidden City Ticket'**
  String get quickItemForbiddenCity;

  /// No description provided for @quickItemSanyaTrip.
  ///
  /// In en, this message translates to:
  /// **'Sanya Package'**
  String get quickItemSanyaTrip;

  /// No description provided for @recentBookings.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentBookings;

  /// No description provided for @hotRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get hotRecommendations;

  /// No description provided for @todayDeals.
  ///
  /// In en, this message translates to:
  /// **'Today\'s deals'**
  String get todayDeals;

  /// No description provided for @hintDisplayName.
  ///
  /// In en, this message translates to:
  /// **'e.g. John Smith'**
  String get hintDisplayName;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'e.g. customer@example.com'**
  String get hintEmail;

  /// No description provided for @hintAvatarUrl.
  ///
  /// In en, this message translates to:
  /// **'https://...'**
  String get hintAvatarUrl;

  /// No description provided for @promotionsDiscountTitle.
  ///
  /// In en, this message translates to:
  /// **'Promos / Discounts'**
  String get promotionsDiscountTitle;

  /// No description provided for @promotionsDiscountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Limited-time offers, use coupons to save'**
  String get promotionsDiscountSubtitle;

  /// No description provided for @travelerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get travelerName;

  /// No description provided for @idCardNumber.
  ///
  /// In en, this message translates to:
  /// **'ID card number'**
  String get idCardNumber;

  /// No description provided for @travelerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get travelerPhone;

  /// No description provided for @addTraveler.
  ///
  /// In en, this message translates to:
  /// **'Add traveler'**
  String get addTraveler;

  /// No description provided for @fillTravelerInfo.
  ///
  /// In en, this message translates to:
  /// **'Fill traveler info'**
  String get fillTravelerInfo;

  /// No description provided for @travelerInfoRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill name, ID card and phone for all travelers'**
  String get travelerInfoRequired;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextStep;

  /// No description provided for @payWithAlipay.
  ///
  /// In en, this message translates to:
  /// **'Alipay'**
  String get payWithAlipay;

  /// No description provided for @payWithWeChat.
  ///
  /// In en, this message translates to:
  /// **'WeChat Pay'**
  String get payWithWeChat;

  /// No description provided for @selectPayment.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get selectPayment;

  /// No description provided for @checkInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkInLabel;

  /// No description provided for @checkOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOutLabel;

  /// No description provided for @bookingDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking details'**
  String get bookingDetailsLabel;

  /// No description provided for @commentsSection.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsSection;

  /// No description provided for @selectDatePackageGuests.
  ///
  /// In en, this message translates to:
  /// **'Select Date / Package / Guests'**
  String get selectDatePackageGuests;

  /// No description provided for @travelPackage.
  ///
  /// In en, this message translates to:
  /// **'Travel Package'**
  String get travelPackage;

  /// No description provided for @departureDate.
  ///
  /// In en, this message translates to:
  /// **'Departure Date'**
  String get departureDate;

  /// No description provided for @numberOfTravelers.
  ///
  /// In en, this message translates to:
  /// **'Number of Travelers'**
  String get numberOfTravelers;

  /// No description provided for @adults12AndAbove.
  ///
  /// In en, this message translates to:
  /// **'Adults 12 years and above'**
  String get adults12AndAbove;

  /// No description provided for @children2To12.
  ///
  /// In en, this message translates to:
  /// **'Children 2–12 years (excl.)'**
  String get children2To12;

  /// No description provided for @spotsLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {count} spots left'**
  String spotsLeft(int count);

  /// No description provided for @allTourDates.
  ///
  /// In en, this message translates to:
  /// **'All tour dates'**
  String get allTourDates;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @fillOrder.
  ///
  /// In en, this message translates to:
  /// **'Fill in Order'**
  String get fillOrder;

  /// No description provided for @itineraryPackage.
  ///
  /// In en, this message translates to:
  /// **'Itinerary Package'**
  String get itineraryPackage;

  /// No description provided for @confirmWithin24h.
  ///
  /// In en, this message translates to:
  /// **'Confirm within 24h: Payment can be confirmed quickly.'**
  String get confirmWithin24h;

  /// No description provided for @needSelectAdultTravelers.
  ///
  /// In en, this message translates to:
  /// **'Need to select {count} adult traveler(s)'**
  String needSelectAdultTravelers(int count);

  /// No description provided for @ensureInfoMatchesId.
  ///
  /// In en, this message translates to:
  /// **'Please ensure the information matches the travel document.'**
  String get ensureInfoMatchesId;

  /// No description provided for @addTravelerButton.
  ///
  /// In en, this message translates to:
  /// **'Add Traveler'**
  String get addTravelerButton;

  /// No description provided for @numberOfRooms.
  ///
  /// In en, this message translates to:
  /// **'Number of Rooms'**
  String get numberOfRooms;

  /// No description provided for @roomSharingInfo.
  ///
  /// In en, this message translates to:
  /// **'1 adult may share a room. To avoid sharing, increase rooms. Single supplement may apply.'**
  String get roomSharingInfo;

  /// No description provided for @roomSharingSelect.
  ///
  /// In en, this message translates to:
  /// **'Select room-sharing members'**
  String get roomSharingSelect;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @realNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Real name *'**
  String get realNameRequired;

  /// No description provided for @enterContactName.
  ///
  /// In en, this message translates to:
  /// **'Enter contact name'**
  String get enterContactName;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalAmount;

  /// No description provided for @submitOrder.
  ///
  /// In en, this message translates to:
  /// **'Submit Order'**
  String get submitOrder;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'/ person'**
  String get perPerson;
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
