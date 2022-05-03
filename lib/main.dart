import 'package:examap/AdminHomePage.dart';
import 'package:examap/AdminSignInPage.dart';
import 'package:examap/studentSignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase options
import 'authentication_service.dart';
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
        title: 'ExamAp',
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

    return const MyHomePage(title: "ExamAp");
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _items = [
    const StudentSignInPage(),
    const AdminSignInPage(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _items,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_rounded),
            label: 'Lector',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
