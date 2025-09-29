// import 'package:bbu212_app/cards/menu/contact_form_screen.dart';
import 'package:bbu212_app/app_colors.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ContactScreen());
String? gender;

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Contacts List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'New Contact',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: DropdownButtonFormField(
                              value: gender,
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: Icon(
                                  Icons.transgender,
                                  color: Colors.blue,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              items: ["Male", "Female"].map((g) {
                                return DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                );
                              }).toList(),
                              onChanged: (val) => gender = val!,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Company',
                                prefixIcon: Icon(
                                  Icons.business,
                                  color: Colors.blue,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.bgColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save, color: AppColors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.fromLTRB(10, 0, 5, 10),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  height: 120,
                  child: Card(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(100, 40, 5, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Chan Dary', style: TextStyle(fontSize: 20)),
                              SizedBox(height: 5),
                              Text(
                                'Female, 012345678',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 30,
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text('bbu sr'.toUpperCase()),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          bottom: 10,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.bgColor,
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: ClipOval(
                                child: Text(
                                  'C',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  height: 120,
                  child: Card(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(100, 40, 5, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Samnang', style: TextStyle(fontSize: 20)),
                              SizedBox(height: 5),
                              Text(
                                'Male, 012345699',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 30,
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text('bbu sr'.toUpperCase()),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          bottom: 10,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.bgColor,
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: ClipOval(
                                child: Text(
                                  'S',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  height: 120,
                  child: Card(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(100, 40, 5, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Veasna', style: TextStyle(fontSize: 20)),
                              SizedBox(height: 5),
                              Text(
                                'Male, 099456654',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 30,
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text('bbu sr'.toUpperCase()),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          bottom: 10,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.bgColor,
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: ClipOval(
                                child: Text(
                                  'V',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
