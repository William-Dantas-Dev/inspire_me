class QuoteCategoryModel {
  const QuoteCategoryModel({
    required this.id,
    required this.label,
  });

  final int id;
  final String label;

  factory QuoteCategoryModel.fromMap(Map<String, dynamic> map) {
    return QuoteCategoryModel(
      id: map['id'] as int,
      label: map['label'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
    };
  }
}