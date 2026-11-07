import 'package:flutter/material.dart';

import 'product_detail.dart';
import 'favorite.dart';
import 'my_rental.dart';
import 'profile.dart';
import 'product_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  Set<String> favoriteProducts = {};

  void toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      final productName = product['name'].toString();

      if (favoriteProducts.contains(productName)) {
        favoriteProducts.remove(productName);
      } else {
        favoriteProducts.add(productName);
      }
    });
  }

  void removeFavorite(Map<String, dynamic> product) {
    setState(() {
      favoriteProducts.remove(product['name'].toString());
    });
  }

  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  int selectedCategory = 0;
  int selectedIndex = 0;

  final List<String> categories = [
    'All',
    'Electronics',
    'Vehicles',
    'Sports',
    'Home',
    'Events',
  ];

  final List<Map<String, dynamic>> products = ProductData.products;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      final matchesSearch = product['name'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final selectedCategoryName = categories[selectedCategory];

      final matchesCategory =
          selectedCategoryName == 'All' ||
          product['category'] == selectedCategoryName;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: selectedIndex,
        children: [
          SafeArea(
            child: Column(
              children: [
                // HEADER DAN SEARCH BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hello, Welcome 👋',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Find Your Rental',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              color: orange,
                              size: 27,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search items to rent...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // AREA YANG BISA DI-SCROLL
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                    children: [
                      // BANNER
                      Container(
                        height: 155,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Rent More,\nSpend Less!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Find everything you need in RentMate.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.shopping_bag_rounded,
                              size: 75,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // CATEGORIES
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final isSelected = selectedCategory == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? black
                                      : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // RECOMMENDED ITEMS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recommended for You',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = 0;
                                searchController.clear();
                                searchQuery = '';
                              });
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // PRODUCT GRID
                      if (filteredProducts.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(30),
                          child: Center(
                            child: Text(
                              'No items found.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.67,
                              ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFEEEEEE),
                                  ),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(16),
                                                ),
                                            child: Image.network(
                                              product['image'],
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: const Color(
                                                        0xFFFFF3E8,
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color: orange,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () {
                                                toggleFavorite(product);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  favoriteProducts.contains(
                                                        product['name']
                                                            .toString(),
                                                      )
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  size: 17,
                                                  color:
                                                      favoriteProducts.contains(
                                                        product['name']
                                                            .toString(),
                                                      )
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['category'],
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            product['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                size: 13,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                product['location'],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                color: orange,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Rp${product['price']}',
                                                ),
                                                const TextSpan(
                                                  text: '/day',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 6),

                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  product['isAvailable'] == true
                                                  ? Colors.green.shade50
                                                  : Colors.red.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              product['isAvailable'] == true
                                                  ? 'Available'
                                                  : 'Not Available',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    product['isAvailable'] ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red,
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
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // HALAMAN FAVORITES
          FavoritesScreen(
            favoriteProducts: products.where((product) {
              return favoriteProducts.contains(product['name'].toString());
            }).toList(),
            onRemoveFavorite: removeFavorite,
            onBack: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),

          // HALAMAN MY RENTALS
          MyRentalsScreen(
            onBack: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          // HALAMAN PROFILE
          const ProfileScreen(),
        ],
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: orange,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
