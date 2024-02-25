import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/state_web/authen_web.dart';
import 'package:studentjo/states/authen.dart';
import 'package:studentjo/states/main_home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

String? firstPage;
var getPages = <GetPage<dynamic>>[
  GetPage(
    name: '/authen',
    page: () => const Authen(),
  ),
  GetPage(
    name: '/mainHome',
    page: () => const MainHome(),
  ),
  GetPage(
    name: '/authenWeb',
    page: () => const AuthenWeb(),
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    //web

    await Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: 'AIzaSyDlaBBOPTQpTRkkAfeJw_xmmR9tVoiEZjU',
                appId: '1:91423500395:web:bbfccbc668343fc0dea92e',
                messagingSenderId: '91423500395',
                projectId: 'studentjo-57f60'))
        .then((value) {
      firstPage = '/authenWeb';
      runApp(const MyApp());
    });
  } else {
    //mobile

    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          firstPage = '/authen';
          runApp(const MyApp());
        } else {
          firstPage = '/mainHome';
          runApp(const MyApp());
        }
      });
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: getPages,
      initialRoute: firstPage,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
