class Word {
  final int? id;
  final String first;
  final String second;
  final int like;

  const Word({
    this.id,
    required this.first,
    required this.second,
    required this.like,
  });
  

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'first': first,
      'second': second,
      'like': like,
    };
  }

  @override
  String toString() {
    return 'Word{id: $id, first: $first, second: $second, like: $like}';
  }
}