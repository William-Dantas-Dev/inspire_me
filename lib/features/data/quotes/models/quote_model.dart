class QuoteModel {
  const QuoteModel({
    required this.id,
    required this.text,
    required this.category,
    required this.author,
    required this.tags,
    required this.active,
  });

  final int id;
  final String text;
  final int category;
  final String? author;
  final List<String> tags;
  final bool active;

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    return QuoteModel(
      id: map['id'] as int,
      text: map['text'] as String,
      category: map['category'] as int,
      author: map['author'] as String?,
      tags: List<String>.from(map['tags'] as List),
      active: map['active'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'author': author,
      'tags': tags,
      'active': active,
    };
  }
}