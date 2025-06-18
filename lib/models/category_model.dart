class Category {
  final int categoryId;
  final String categoryName;
  final String categoryImage;
  final String categoryDescription;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryDescription,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
      categoryDescription: json['category_description'],
    );
  }
}