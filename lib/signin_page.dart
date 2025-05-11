// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:recipe_app/firebase_services.dart';
import 'package:recipe_app/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/main.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showpass=false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<User?> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-in cancelled by user.")),
        );
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
 FirebaseServices().createUserDocument(userCredential.user!.uid.toString());
      setState(() {
        _isLoading = false;
       
      });
 await storage.write(key: "UserID", value: userCredential.user?.uid.toString());
      return userCredential.user;
    } catch (e) {
      setState(() {
        _isLoading = false;
     
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during sign-in: $e")),
      );

      return null;
    }
  }

  Future<User?> _signInWithEmailPassword(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      await storage.write(key: "UserID", value: userCredential.user?.uid.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${userCredential.user?.uid.toString()}")),
      );


      setState(() {
        _isLoading = false;
      });
      return userCredential.user;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
     

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during email sign-in: $e")),
      );

      return null;
    }
  }

  Future<void> _registerWithEmailPassword(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await storage.write(key:"UserID", value: userCredential.user?.uid );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${userCredential.user?.uid}")),
      );FirebaseServices().createUserDocument(userCredential.user!.uid.toString());
    try {
      setState(() {
    
    
        _isLoading = false;
         
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful!")),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during registration: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      body: Stack(
        children: [
          
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/signin_bg.jpg',
              fit: BoxFit.fill,
            ),
          ),
          
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  
                  Column(
                    children: [
                       Text(
                        'RECIPE APP',
                        style: TextStyle(color: Colors.grey[50],
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          'assets/images/signinpage_logo.jpg',
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50), 

                  TextField(cursorColor: Colors.black26,
                    controller: _emailController,
                    decoration: const InputDecoration(fillColor: Color.fromARGB(224,239,245,255),filled: true,
                      hintText: 'Email',contentPadding: EdgeInsets.only(left: 25,right: 10),suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.email_outlined,),
                      ),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35)),borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35)),borderSide: BorderSide(
                        color: Colors.transparent
                      ))
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(cursorColor: Colors.black26,
                    controller: _passwordController,
                    obscureText: !showpass,
                    decoration:  InputDecoration(suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(icon:  const Icon(Icons.lock_outline),onPressed: (){
                        setState(() {
                          showpass=!showpass;
                        });
                      },),
                    ),contentPadding: const EdgeInsets.only(left: 25),
                      hintText: 'Password',fillColor:const Color.fromARGB(224,239,245,255),filled: true,
                      enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35)),borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35)),borderSide: BorderSide(
                        color: Colors.transparent
                      )),
                      

                    ),
                  ),
                  const SizedBox(height: 20),
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                        onPressed: () async { FocusManager.instance.primaryFocus?.unfocus();
                          User? user = await _signInWithEmailPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          if (user != null) {
                            print('Signed in as ${user.email}');
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Homepage(),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Sign In',style: TextStyle(color: Colors.grey[100]),),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                        onPressed: () async{ FocusManager.instance.primaryFocus?.unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    try {
      await _registerWithEmailPassword(email, password);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      }
    } catch (e) {_isLoading=false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
      );
    }
  },
                        child:  Text('Register',style: TextStyle(color: Colors.grey[100]),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(children: [Expanded(child: Divider(indent: 0,)),Padding(padding: EdgeInsets.all(5),child: Text('OR',style: TextStyle(fontSize: 20,color: Colors.white),),),Expanded(child: Divider())]),
                  const SizedBox(height: 20),
     
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                    onPressed: () async { FocusManager.instance.primaryFocus?.unfocus();
                      User? user = await _signInWithGoogle();
                      if (user != null) {
                        print('Signed in as ${user.displayName}');
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Homepage(),
                            ),
                          );
                        }
                      }
                    },
                    child:  Text('Sign In with Google',style: TextStyle(color: Colors.grey[100]),),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
      
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
