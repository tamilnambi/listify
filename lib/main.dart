import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listify/pages/splash_page.dart';
import 'package:listify/services/providers/providers_list.dart';
import 'package:listify/util/shared_preferences_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesService().initPrefs();
  runApp(MultiProvider(
      providers: ProviderList.getProviders(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [BotToastNavigatorObserver()],
        title: 'Listify',
        theme: ThemeData(
          useMaterial3: true,
        ),
        builder: (context, widget) {
          widget = botToastBuilder(context, widget);
          return widget;
        },
        home: const SplashPage());
  }
}
