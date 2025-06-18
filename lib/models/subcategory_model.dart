class Subcategory {
  final int subcategoryId;
  final String subcategoryName;
  final String subcategoryDescription;
  final int categoryId;

  Subcategory({
    required this.subcategoryId,
    required this.subcategoryName,
    required this.subcategoryDescription,
    required this.categoryId,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      subcategoryId: json['subcategory_id'],
      subcategoryName: json['subcategory_name'],
      subcategoryDescription: json['subcategory_description'],
      categoryId: json['category_id'],
    );
  }
}