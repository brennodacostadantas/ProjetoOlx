import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/RouteGenerator.dart';
import 'package:olx/views/Anuncios.dart';
import 'package:olx/firebase_options.dart';

final ThemeData temaPadrao = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff9c27b0), secondary: const Color(0xff7b1fa2)));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    title: "OLX",
    home: const Anuncios(),
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
