class Score {
  final String userId;
  final String username;
  final int score;

  Score({
    required this.userId,
    required this.username,
    this.score = 0,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'username': username,
        'score': score,
      };

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      userId: map['userId'] as String,
      username: map['username'] as String,
      score: map['score'] as int,
    );
  }
  @override
  String toString() => toMap().toString();
}
