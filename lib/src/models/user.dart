import 'package:meta/meta.dart';

@immutable
final class User {
  final String name;
  final String id; // TODO: probably should map to Firebase Authentication id.

  User({required this.name, required this.id});

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? '',
        name = map['name'] ?? '';

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  @override
  String toString() => toMap().toString();
}
