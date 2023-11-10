import 'package:clique_king_model/src/models/score.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

// TODO: Remove scores here, it as added as collection
@immutable
class Clique {
  final String id;
  final String name;

  Clique.onCreate({
    required this.name,
  }) : id = Uuid().v4();

  Clique({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  factory Clique.fromMap(Map<String, dynamic> map) {
    return Clique(
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }

  @override
  String toString() => toMap().toString();
}
