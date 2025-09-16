import 'package:bbu212_app/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SingUpUser extends StatefulWidget {
  const SingUpUser({super.key});

  @override
  State<SingUpUser> createState() => _SingUpUserState();
}

class _SingUpUserState extends State<SingUpUser> {
  bool isPassword = true;
  bool isConfirmPassword = true;
  final txt = FocusNode();
  void togglePassword() {
    setState(() {
      isPassword = !isPassword;
      if (txt.hasPrimaryFocus) return;
      txt.canRequestFocus = false;
    });
  }

  void toggleConfirmPassword() {
    setState(() {
      isConfirmPassword = !isConfirmPassword;
      if (txt.hasPrimaryFocus) return;
      txt.canRequestFocus = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  Future<void> signupUser(
    String fullname,
    String email,
    String password,
  ) async {
    try {
      EasyLoading.show(status: 'Please wait...');
      await Future.delayed(Duration(seconds: 1));
      // create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;

      // save user information with firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fullname': fullname,
        'email': email,
        'createdAt': DateTime.now(),
      });
      EasyLoading.showSuccess('User registered successfully');
      if (!mounted) return;
      Navigator.pop(context);
    } catch (ex) {
      EasyLoading.showError('Error: $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sign Up User',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: Image.asset(
                'assets/images/personal.png',
                width: 120,
                height: 120,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                controller: controllerFullName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Full Name',
                  labelStyle: TextStyle(fontFamily: 'JetBrainsMono'),
                  prefixIcon: Icon(Icons.account_circle),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                controller: controllerEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(fontFamily: 'JetBrainsMono'),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                controller: controllerPassword,
                obscureText: isPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(fontFamily: 'JetBrainsMono'),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: GestureDetector(
                      onTap: togglePassword,
                      child: Icon(
                        isPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != controllerPassword.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                controller: controllerConfirmPassword,
                obscureText: isPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(fontFamily: 'JetBrainsMono'),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: GestureDetector(
                      onTap: togglePassword,
                      child: Icon(
                        isPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 55,
              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String fullname = controllerFullName.text;
                    String email = controllerEmail.text;
                    String password = controllerPassword.text.trim();
                    signupUser(fullname, email, password);
                  }
                },
                child: Text(
                  'SIGN UP',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
