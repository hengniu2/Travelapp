import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_provider.dart';
import 'utils/app_theme.dart';
import 'screens/main_navigation.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext _) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = AppProvider();
        // init() always sets isInitialized in finally, so splash never stays infinite
        provider.init().catchError((error) {
          debugPrint('Error initializing app: $error');
        });
        return provider;
      },
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp(
            title: 'Travel App',
            theme: AppTheme.lightTheme,
            locale: appProvider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('zh'),
            ],
            home: _buildHome(appProvider),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  Widget _buildHome(AppProvider appProvider) {
    if (!appProvider.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }
    if (appProvider.currentUser == null) {
      return const LoginScreen();
    }
    return const MainNavigation();
  }
}