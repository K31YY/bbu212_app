import 'package:bbu212_app/app_colors.dart';
import 'package:bbu212_app/sing_up_user.dart';
import 'package:bbu212_app/app_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  bool ispassword = true;
  final txt = FocusNode();
  void togglePassword() {
    setState(() {
      ispassword = !ispassword;
      if (txt.hasPrimaryFocus) return;
      txt.canRequestFocus = false;
    });
  }

  final _keyForm = GlobalKey<FormState>();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  Future<void> LoginUser(String email, String password) async {
    try {
      EasyLoading.show(status: 'Please wait...');
      await Future.delayed(Duration(seconds: 1));
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        // login succesed
        // save user login infor
        final sp = await SharedPreferences.getInstance();

        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

        sp.setString('UID', user.uid);
        sp.setString('FULLNAME', data['fullname']);
        sp.setString('EMAIL', data['email']);

        EasyLoading.dismiss();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppDashboard()),
          (route) => false,
        );
      } else {
        EasyLoading.showError('Login Failed');
      }
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
          'Login User',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ),
      body: Form(
        key: _keyForm,
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
                obscureText: ispassword,
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
                        ispassword
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
                  if (_keyForm.currentState!.validate()) {
                    String email = controllerEmail.text.trim();
                    String password = controllerPassword.text.trim();
                    LoginUser(email, password);
                  }
                },
                child: Text('LOGIN', style: TextStyle(color: AppColors.white)),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.bgColor,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Does not have account?',
                  style: TextStyle(fontFamily: 'JetBrainsMono'),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SingUpUser()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppColors.bgColor,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
