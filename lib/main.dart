import 'package:examap/AdminHomePage.dart';
import 'package:examap/SignInPage.dart';
import 'package:examap/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase options
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().onAuthStateChanged,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Firestore Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminUser = context.watch<User?>();

    if (adminUser != null) {
      return const AdminHomePage();
    }

    return Signinpage();
  }
}
