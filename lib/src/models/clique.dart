import 'package:clique_king_model/src/models/score.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class Clique {
  final String? id;
  final String name;
  final List<Score> scores;

  Clique.onCreate({
    required this.name,
  })  : id = Uuid().v4(),
        scores = const [];

  Clique({
    required this.id,
    required this.name,
    required this.scores,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'score': scores,
      };

  factory Clique.fromMap(Map<String, dynamic> map) {
    return Clique(
      name: map['name'] as String,
      id: map['id'] as String,
      scores: (map['score'] as List).map((map) => Score.fromMap(map)).toList(),
    );
  }
}
