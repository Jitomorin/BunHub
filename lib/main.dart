import 'package:bunhub_app/layout/mobile_layout.dart';
import 'package:bunhub_app/layout/responsive_screen_layout.dart';
import 'package:bunhub_app/layout/web_screen_layout.dart';
import 'package:bunhub_app/screens/home_screen.dart';
import 'package:bunhub_app/utilities/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //for mobile
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProv>(
          create: (_) => UserProv(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BunHub',
          theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mainC),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponiveLayout(
                      MobileScreenLayout: MobileLayout(),
                      WebScreenLayout: WebScreenLayout(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //as were waiting for authentication display circularr progress indicator
                  return const Center(
                    child: CircularProgressIndicator(color: actionC),
                  );
                }
                return const LoginScreen();
              }))),
    );
  }
}
