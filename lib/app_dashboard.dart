import 'package:bbu212_app/app_colors.dart';
import 'package:bbu212_app/cards/contact_screen.dart';
import 'package:bbu212_app/cards/menu/favoriet_itmes.dart';
import 'package:bbu212_app/cards/menu/navigation_menu.dart';
import 'package:bbu212_app/cards/menu/new_oder.dart';
import 'package:bbu212_app/cards/menu/popular_items.dart';
import 'package:bbu212_app/categories_screen.dart';
import 'package:bbu212_app/grorp_screen.dart';
import 'package:bbu212_app/help_screen.dart';
import 'package:bbu212_app/product_screen.dart';
import 'package:bbu212_app/setting_screen.dart';
// import 'package:bbu212_app/shope.dart';
import 'package:flutter/material.dart';

class AppDashboard extends StatefulWidget {
  const AppDashboard({super.key});

  @override
  State<AppDashboard> createState() => _AppDashboardState();
}

class _AppDashboardState extends State<AppDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BBU STORE'),
        actions: [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: ListTile(
                leading: Icon(Icons.add_shopping_cart),
                title: Text('New Order'),
              ),
            ),
             PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Popular Items'),
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: ListTile(
                leading: Icon(Icons.favorite, color: AppColors.red,),
                title: Text('Favorite Items'),
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewOder()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PopularItems()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriteItems()));
                break;
            }
          },
          ),
        ],
      ),
      drawer: const NavigationMenu(),
      body: Container(
        color: AppColors.bgHome,
        child: Stack(
          children: <Widget> [
            // background
            Container(
              height: 80,
              decoration: BoxDecoration(
                 color: AppColors.bgColor,
                 borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                 )
              ),
            ),
            // contents
            ListView(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 140,
                child: Card(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          'Good Afternoon',
                          style: TextStyle(

                            color: AppColors.bgColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 36, 10, 10),
                        child: Text('BTB 212'),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Row(
                          children: <Widget> [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.bgColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                )
                              ),
                              onPressed: () {},
                               child:Text('My Orders'.toUpperCase(),
                               style: TextStyle(
                                color: AppColors.white,
                               ),
                             ),
                            ),
                            SizedBox(width: 10),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              onPressed: () {}, child: Text('Top New'.toUpperCase(),
                              style: TextStyle(
                                color: AppColors.bgColor,
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        bottom: 10,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.bgColor,
                          child: Padding(padding: EdgeInsets.all(3),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/IMG_0633.JPG',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ),
              GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                // Card 1
                cardBox('Contacts', Icons.person),
                // Card 2
                cardBox('Groups', Icons.group),
                // Card 3
                cardBox('Products', Icons.shopping_cart,
                ),
                // Card 4
                cardBox('Categories', Icons.playlist_add_check),
                // Card 5
                cardBox('Help', Icons.question_mark),
                // Card 6
                cardBox('Settings', Icons.settings),
              ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget cardBox(
    String title,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return SizedBox(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
           // InkWell, InkRespone, GestureDetector
           child: InkWell(
            onTap: () {
              if(title == 'Contacts'){
                // Navigate to Contacts page
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const ContactScreen())
                );
              }else if(title == 'Groups'){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const GrorpScreen())
                );
              }else if(title == 'Products'){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProductScreen())
                );
              }else if(title == 'Categories'){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CategoriesScreen())
                );
              }else if(title == 'Help'){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpScreen())
                );
              }else if(title == 'Settings'){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingScreen())
                );
              }
            },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(180),
                ),
                child: Icon(
                  icon,
                  size: 55,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: AppColors.bgColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}