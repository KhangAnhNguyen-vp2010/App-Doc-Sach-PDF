import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project_flutter/screens/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'Provider/PdfActionsProvider.dart';
import 'Provider/PdfProvider.dart';


void main() async {
  await Hive.initFlutter();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PdfProvider()),
      ChangeNotifierProvider(create: (_) => PdfActionsProvider()),
    ],
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

