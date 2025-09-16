import 'package:bbu212_app/app_colors.dart';
import 'package:flutter/material.dart';


class MyShope extends StatelessWidget {
  const MyShope({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgHome,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.person_outline, color: Colors.black),
            SizedBox(width: 10),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        selectedItemColor: AppColors.bgColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        shrinkWrap: true,
        children: <Widget>[
          // card 1
          cardBox('assets/images/peoplegroup.png', 'Living room'),
          // card 2
          cardBox('assets/images/light.png', 'Desk lamp'),
          // card 3
          cardBox('assets/images/light.png', 'Garage door'),
          // card 4
          cardBox('assets/images/kids.png', 'Kids room'),
          // card 5
          cardBox('assets/images/peoplegroup.png', 'People group'),
          // card 6
          cardBox('assets/images/light.png', 'Floor lamp'),
        ],
      ),
    );
  }

  
  Widget cardBox(
    String imagePath,
    String title,
  ){
    return SizedBox(
      child:   Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // to align text to the start
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          title.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center( // to center the image
                        child: Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                           // color: AppColors.bgColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              imagePath,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}