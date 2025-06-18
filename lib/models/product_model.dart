class Product {
  final int productId;
  final String productName;
  final String productImage;
  final String productDescription;
  final double productPrice;
  final String? categoryName;
  final String? subcategoryName;
  final int? categoryId;
  final int? subcategoryId;

  Product({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productDescription,
    required this.productPrice,
    this.categoryName,
    this.subcategoryName,
    this.categoryId,
    this.subcategoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      productDescription: json['product_description'],
      productPrice: (json['product_price'] ?? 0.0).toDouble(),
      categoryName: json['category_name'],
      subcategoryName: json['subcategory_name'],
      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
    );
  }
}