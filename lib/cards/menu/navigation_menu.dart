import 'package:bbu212_app/app_colors.dart';
import 'package:bbu212_app/app_dashboard.dart';
import 'package:bbu212_app/cards/menu/about_us.dart';
import 'package:bbu212_app/cards/menu/change_password.dart';
import 'package:bbu212_app/cards/menu/contact_us.dart';
import 'package:bbu212_app/cards/menu/faqs.dart';
import 'package:bbu212_app/cards/menu/feedback.dart';
import 'package:bbu212_app/cards/menu/invite_friend.dart';
import 'package:bbu212_app/cards/menu/my_profile.dart';
import 'package:bbu212_app/cards/menu/promotion.dart';
import 'package:bbu212_app/cards/menu/terms_of_us.dart';
import 'package:bbu212_app/login_user.dart';
import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Kheourt Sokhy'),
            accountEmail: Text('kheourtsokhy@bb.bbu.edu.kh'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/IMG_0629.JPG',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(color: AppColors.bgColor),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUs()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.phone_in_talk),
            title: Text('Contact Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUs()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Promotions'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Promotion()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('FAQs'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Faqs()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Feedback'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Feedbacks()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Terms of Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsOfUs()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Invite Friends'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InviteFriend()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.password),
            title: Text('Change Password'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePassword()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AppDashboard()),
                (route) => true,
              );
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirm Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppDashboard(),
                          ),
                          (route) => true,
                        );
                      },
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginUser(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
