import '../screens/edit_post.dart';
import '../screens/new_post.dart';
import '../screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/seller_home_screen.dart';
import 'package:flutter/material.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String docsRef;
  String documentId;
  var docList;
  static const MaterialColor kPrimaryColor = const MaterialColor(
    0xFF4e51bf,
    const <int, Color>{
      50: const Color(0xFF0E7AC7),
      100: const Color(0xFF0E7AC7),
      200: const Color(0xFF0E7AC7),
      300: const Color(0xFF0E7AC7),
      400: const Color(0xFF0E7AC7),
      500: const Color(0xFF0E7AC7),
      600: const Color(0xFF0E7AC7),
      700: const Color(0xFF0E7AC7),
      800: const Color(0xFF0E7AC7),
      900: const Color(0xFF0E7AC7),
    },
  );
  @override
  build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: Splash());
          } else {
            // Loading is done, return the app:
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'FlutterChat',
              theme: ThemeData(
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                primarySwatch: kPrimaryColor,
              ),
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.hasData) {
                    return SellerScreen(docsRef);
                  }
                  return AuthScreen();
                },
              ),
              routes: {
                EditPost.routeName: (context) => EditPost(documentId, docList),
                NewPost.routeName: (context) => NewPost(),
                SellerScreen.routeName: (context) => SellerScreen(documentId),
              },
            );
          }
        });
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4e51bf),
      body: Center(child: FlutterLogo(size:100,)),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {

    await Future.delayed(Duration(seconds: 5));
  }
}
