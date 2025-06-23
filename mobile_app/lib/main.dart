import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile_app/Providers/ThemeProvider.dart';
import 'package:mobile_app/screens/Layouts/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'Providers/BookProvider.dart';
import 'Providers/LanguageProvider.dart';
import 'generated/l10n.dart';  // import file sinh ra


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final languageProvider = LanguageProvider();
  await languageProvider.init();  // load ngôn ngữ đã lưu

  final themeProvider = ThemeProvider();
  await themeProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageProvider>().locale;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(),
    );
  }
}

