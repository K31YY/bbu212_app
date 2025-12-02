// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:bbu212_app/app_colors.dart';
import 'package:bbu212_app/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class FirestoreSearch extends SearchDelegate<Contact?> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String uid;

  FirestoreSearch({required this.uid});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  // Show search results
  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        // child: Text(
        //   "Type name to search...",
        //   style: TextStyle(color: Colors.grey[600]),
        // ),
      );
    }

    // Firestore query: search firstname or lastname
    final Stream<List<Contact>> stream = firestore
        .collection('contacts')
        .where('createdby', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    Contact.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .where(
                (c) =>
                    c.firstname.toLowerCase().contains(query.toLowerCase()) ||
                    c.lastname.toLowerCase().contains(query.toLowerCase()),
              )
              .toList(),
        );

    return StreamBuilder<List<Contact>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final results = snapshot.data!;
        if (results.isEmpty) return Center(child: Text('No contacts found'));

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final contact = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.bgColor,
                child: Text(
                  contact.firstname.isNotEmpty ? contact.firstname[0] : '?',
                ),
              ),
              title: Text('${contact.firstname} ${contact.lastname}'),
              subtitle: Text('${contact.gender}, ${contact.phone}'),
              onTap: () => close(context, contact),
            );
          },
        );
      },
    );
  }

  // Show suggestions while typing
  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _keyForm = GlobalKey<FormState>();
  final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Stream<List<Contact>> getContacts({bool onlyFavourites = false}) {
    String uid = _auth.currentUser!.uid;
    Query query = _firestoredb
        .collection('contacts')
        .where('createdby', isEqualTo: uid);

    if (onlyFavourites) query = query.where('isFavourite', isEqualTo: true);

    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                Contact.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList(),
    );
  }

  Future<void> toggleFavourite(Contact contact) async {
    await _firestoredb.collection('contacts').doc(contact.id).update({
      'isFavourite': !contact.isFavourite,
    });
    EasyLoading.showSuccess(
      contact.isFavourite ? 'Removed from Favourites' : 'Added to Favourites',
    );
  }

  Future<void> deleteContact(
    BuildContext context,
    String id,
    String name,
  ) async {
    final isDeleted = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text("Are you sure you want to delete contact: '$name'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('NO'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('YES'),
          ),
        ],
      ),
    );

    if (isDeleted == true) {
      EasyLoading.show();
      await Future.delayed(Duration(seconds: 1));
      await _firestoredb.collection('contacts').doc(id).delete();
      EasyLoading.showSuccess('Contact deleted.');
    }
  }

  void _addContactDialog(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    final companyController = TextEditingController();
    String? gender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Form(
          key: _keyForm,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'New Contact',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: firstNameController,
                  validator: (value) =>
                      value!.isEmpty ? 'First name is required!' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.person, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: lastNameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Last name is required!' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Last Name',
                    prefixIcon: Icon(
                      Icons.person_add_alt,
                      color: AppColors.bgColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: gender,
                  validator: (value) =>
                      value == null ? 'Gender is required!' : null,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(
                      Icons.transgender,
                      color: AppColors.bgColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: ['Male', 'Female']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),

                  onChanged: (val) => gender = val,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  validator: (value) =>
                      value!.isEmpty ? 'Phone number is required!' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: companyController,
                  validator: (value) =>
                      value!.isEmpty ? 'Company is required!' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Company',
                    prefixIcon: Icon(Icons.home, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_keyForm.currentState!.validate()) {
                      EasyLoading.show();
                      await _firestoredb.collection('contacts').add({
                        'firstname': firstNameController.text,
                        'lastname': lastNameController.text,
                        'gender': gender,
                        'phone': phoneController.text,
                        'company': companyController.text,
                        // 'isFavourite': false,
                        'createdby': _auth.currentUser!.uid,
                        'createdAt': DateTime.now(),
                      });
                      EasyLoading.showSuccess('Contact added');
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.save, color: AppColors.white),
                  label: Text('Save', style: TextStyle(color: AppColors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bgColor,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateContaceDialog(BuildContext context, Contact contact) {
    final firstNameController = TextEditingController(text: contact.firstname);
    final lastNameController = TextEditingController(text: contact.lastname);
    final phoneController = TextEditingController(text: contact.phone);
    final companyController = TextEditingController(text: contact.company);
    String gender = contact.gender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Form(
          key: _keyForm,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Update Contact',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: firstNameController,
                  validator: (value) =>
                      value!.isEmpty ? 'First name is required!' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.person, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: lastNameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Last name is required!' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Last Name',
                    prefixIcon: Icon(
                      Icons.person_add_alt,
                      color: AppColors.bgColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: gender,
                  validator: (value) =>
                      value == null ? 'Gender is required!' : null,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(
                      Icons.transgender,
                      color: AppColors.bgColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: ['Male', 'Female']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) => gender = val!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  validator: (value) =>
                      value!.isEmpty ? 'Phone number is required!' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: companyController,
                  validator: (value) =>
                      value!.isEmpty ? 'Company is required!' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Company',
                    prefixIcon: Icon(Icons.home, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_keyForm.currentState!.validate()) {
                      EasyLoading.show();
                      final updateContact = Contact(
                        id: contact.id,
                        firstname: firstNameController.text,
                        lastname: lastNameController.text,
                        gender: gender,
                        phone: phoneController.text,
                        company: companyController.text,
                        isFavourite: contact.isFavourite,
                        createdAt: contact.createdAt,
                      );
                      await _firestoredb
                          .collection('contacts')
                          .doc(contact.id)
                          .update(updateContact.toMap());
                      EasyLoading.showSuccess('Contact updated');
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.save, color: AppColors.white),
                  label: Text('Save', style: TextStyle(color: AppColors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bgColor,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContactList({bool recent = false, bool favourites = false}) {
    return StreamBuilder<List<Contact>>(
      stream: getContacts(onlyFavourites: favourites),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        List<Contact> contacts = snapshot.data!;
        if (recent) contacts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (contacts.isEmpty) return Center(child: Text('No Contacts...'));

        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.bgColor,
                  child: Text(
                    contact.firstname.isNotEmpty ? contact.firstname[0] : '?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('${contact.firstname} ${contact.lastname}'),
                subtitle: Text('${contact.gender}, ${contact.phone}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IconButton(
                    //   icon: Icon(
                    //     contact.isFavourite
                    //         ? Icons.favorite
                    //         : Icons
                    //               .favorite_border, //////////////////////////////////////////
                    //     color: Colors.orange,
                    //   ),
                    //   onPressed: () => toggleFavourite(contact),
                    // ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _updateContaceDialog(context, contact);
                        } else if (value == 'delete') {
                          deleteContact(
                            context,
                            contact.id,
                            '${contact.firstname} ${contact.lastname}',
                          );
                        } else if (value == 'favourite') {
                          toggleFavourite(contact);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: AppColors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'favourite',
                          child: Row(
                            children: [
                              Icon(
                                contact.isFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: AppColors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                contact.isFavourite
                                    ? 'Remove from Favourites'
                                    : 'Add to Favourites',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FirestoreSearch(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                ),
              );
            },
          ),

          IconButton(
            onPressed: () => _addContactDialog(context),
            icon: Icon(Icons.person_add_alt_1),
          ),
        ],
      ),

      body: Column(
        children: [
          // ---------------- TAB BAR IN BODY ----------------
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color.fromARGB(255, 96, 174, 239),
              tabs: const [
                Tab(text: '  All Contacts  '),
                Tab(text: '  Recent  '),
                Tab(text: '  Favourites  '),
              ],
            ),
          ),

          // ---------------- TAB CONTENT ----------------
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildContactList(), // All
                buildContactList(recent: true), // Recent
                buildContactList(favourites: true), // Favourites
              ],
            ),
          ),
        ],
      ),
    );
  }
}
