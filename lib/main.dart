import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'services/location_service.dart';
import 'services/media_service.dart';
import 'services/audio_service.dart';
import 'services/storage_service.dart';
import 'services/profile_service.dart';
import 'services/security_service.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const CieloObsApp());
}

class CieloObsApp extends StatelessWidget {
  const CieloObsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => DatabaseService.instance),
        Provider(create: (_) => LocationService()),
        Provider(create: (_) => MediaService()),
        Provider(create: (_) => AudioService()),
        Provider(create: (_) => StorageService.instance),
        Provider(create: (_) => ProfileService()),
        Provider(create: (_) => SecurityService()),
      ],
      child: MaterialApp(
        title: 'CieloObs',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const SplashScreen(),
      ),
    );
  }
}