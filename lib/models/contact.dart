import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String firstname;
  final String lastname;
  final String gender;
  final String phone;
  final String company;
  final bool isFavourite;
  final DateTime createdAt;

  Contact({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.gender,
    required this.phone,
    required this.company,
    this.isFavourite = false,
    required this.createdAt,
  });

  factory Contact.fromMap(Map<String, dynamic> data, String documentId) {
    DateTime createdAt = DateTime.now(); // default fallback

    if (data['createdAt'] != null) {
      var raw = data['createdAt'];

      if (raw is Timestamp) {
        createdAt = raw.toDate();
      } else if (raw is DateTime) {
        createdAt = raw;
      } else if (raw is int) {
        // stored as milliseconds
        createdAt = DateTime.fromMillisecondsSinceEpoch(raw);
      }
    }

    return Contact(
      id: documentId,
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      company: data['company'] ?? '',
      isFavourite: data['isFavourite'] ?? false,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'phone': phone,
      'company': company,
      'isFavourite': isFavourite,
      'createdAt': createdAt,
    };
  }
}
