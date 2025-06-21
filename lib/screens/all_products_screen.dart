import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:groza/models/product_model.dart';
import 'package:groza/screens/product_detail_screen.dart';
import 'package:groza/screens/user_profile.dart';
import 'package:groza/services/ip_storage.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../services/api_service.dart';

class AllProductsScreen extends StatefulWidget {
  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late Future<List<Product>> productsFuture;
  Map<String, List<Product>> categorizedProducts = {};

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    productsFuture = apiService.getProducts().then((products) {
      // Group products by category
      for (var product in products) {
        String category = product.categoryName ?? 'Uncategorized';
        if (!categorizedProducts.containsKey(category)) {
          categorizedProducts[category] = [];
        }
        categorizedProducts[category]!.add(product);
      }
      return products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Groza Mart', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.green[800],
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Delivering to: Home • 30-45 min',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
          // Products List
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerLoading();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading products'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products available'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: categorizedProducts.length,
                  itemBuilder: (context, index) {
                    String category = categorizedProducts.keys.elementAt(index);
                    List<Product> categoryProducts = categorizedProducts[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Header with See All button
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to category specific screen if needed
                                },
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        // Products Horizontal List
                        Container(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryProducts.length,
                            itemBuilder: (context, productIndex) {
                              Product product = categoryProducts[productIndex];
                              return _buildProductCard(product);
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: 3, // Number of shimmer category placeholders
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header Shimmer
            Shimmer(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      height: 24,
                      color: Colors.grey[300],
                    ),
                    Container(
                      width: 60,
                      height: 24,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            // Products Horizontal List Shimmer
            Container(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4, // Number of shimmer product placeholders
                itemBuilder: (context, productIndex) {
                  return Shimmer(
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image Shimmer
                          Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                          // Product Details Shimmer
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 16,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 4),
                                Container(
                                  width: 60,
                                  height: 16,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  height: 30,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    String myip = IpManager.currentIp;
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: 'http://$myip:8000/storage/${product.productImage}',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  child: Container(
                    height: 120,
                    color: Colors.grey[200],
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: Icon(Icons.error),
                ),
              ),
            ),
            // Product Details
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.productPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Icon(Icons.add, size: 16),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}