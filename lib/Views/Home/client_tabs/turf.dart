import 'package:cloud_firestore/cloud_firestore.dart';

class Turf {
  final String id;
  final String name;
  final String type;
  final double price;
  final String? imageUrl;
  final String? description;
  final GeoPoint? location;

  Turf({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.imageUrl,
    this.description,
    this.location,
  });

  factory Turf.fromMap(Map<String, dynamic> map) {
    return Turf(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'],
      description: map['description'],
      location: map['location'] as GeoPoint?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'location': location,
    };
  }
}