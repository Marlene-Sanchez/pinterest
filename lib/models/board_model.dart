class Board {
  final String id;
  final String name;
  final String userId;
  final DateTime createdAt;

  Board({
    required this.id,
    required this.name,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  factory Board.fromMap(String id, Map<String, dynamic> map) {
    return Board(
      id: id,
      name: map['name'],
      userId: map['userId'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}