import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recipe_app/global.dart';
import 'package:recipe_app/homepage.dart';
import 'package:recipe_app/signin_page.dart';


 const storage = FlutterSecureStorage();
Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 late Future<String?> uid;
 

  @override
  void initState() {
    super.initState();
   uid=storage.read(key:'UserID');
    
    
    
  }
  @override
  
  Widget build(BuildContext context) {
     
    return FutureBuilder<String?>(
      future: uid,
      builder: (context, snapshot) {
        // Show loading indicator while waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        // If an error occurs
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('An error occurred.'),
              ),
            ),
          );
        }

        // Navigate based on user ID presence
        final uid = snapshot.data;
        userID=uid.toString();
        return MaterialApp(
          home: uid == null ? const SignInPage() : const Homepage(),
        );
      },
    );
  }
}




