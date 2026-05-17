import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_space/app/router.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  //runApp(ProviderScope(
     //overrides: [
     //  onboardingCompleteProvider.overrideWith((ref) => true),
     //  authStateProvider.overrideWith((ref) => true),
     //],
    //child: const MindSpaceApp(),
  //));
  runApp(ProviderScope(
  child: const MindSpaceApp(),
));
}
