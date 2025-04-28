import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
import '../providers/cart_provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../models/product.dart';
import '../utils/constants.dart';

@RoutePage()
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> _products = [];
  final _faker = Faker();
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Electronics', 'Accessories', 'Home', 'Office'];
  
  @override
  void initState() {
    super.initState();
    _generateProducts();
  }
  
  void _generateProducts() {
    // Generate 20 random products using Faker
    for (int i = 0; i < 20; i++) {
      final id = 'p${i + 1}';
      final name = _generateProductName();
      final price = double.parse((_faker.randomGenerator.decimal(scale: 100, min: 5)).toStringAsFixed(2));
      
      _products.add(Product(
        id: id,
        name: name,
        price: price,
      ));
    }
  }
  
  String _generateProductName() {
    final productTypes = [
      'Smartphone', 'Headphones', 'Laptop', 'Tablet', 'Smart Watch', 
      'Camera', 'Speaker', 'Monitor', 'Keyboard', 'Mouse',
      'Charger', 'Power Bank', 'USB Cable', 'Case', 'Screen Protector',
      'Earbuds', 'Desk', 'Lamp', 'Chair', 'Backpack'
    ];
    
    final adjectives = [
      'Premium', 'Wireless', 'Ergonomic', 'Ultra', 'Pro', 'Elite',
      'Advanced', 'Deluxe', 'Smart', 'Portable', 'Compact',
      'High-End', 'Budget', 'Luxury', 'Essential'
    ];
    
    final brands = [
      'TechPro', 'Nexus', 'ZenTech', 'Fusion', 'Prime', 'Alpha',
      'Omega', 'Vertex', 'Pinnacle', 'Echo', 'Pulse', 'Element'
    ];
    
    // Randomly decide whether to use a brand name
    final useBrand = _faker.randomGenerator.boolean();
    
    if (useBrand) {
      final brand = brands[_faker.randomGenerator.integer(brands.length)];
      final adjective = adjectives[_faker.randomGenerator.integer(adjectives.length)];
      final type = productTypes[_faker.randomGenerator.integer(productTypes.length)];
      return '$brand $adjective $type';
    } else {
      final adjective = adjectives[_faker.randomGenerator.integer(adjectives.length)];
      final type = productTypes[_faker.randomGenerator.integer(productTypes.length)];
      return '$adjective $type';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final userName = sessionProvider.currentUserName;
    final isCreator = sessionProvider.isCreator;
    
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text(
          isCreator ? 'Products (Creator)' : 'Products (Friend)',
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: kWhiteColor,
          ),
        ),
        backgroundColor: kPurpleColor,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: kWhiteColor),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  context.router.push(const SharedCartRoute());
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: kErrorColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea( // Wrap the main Column with SafeArea
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header gradient container (similar to home screen)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPurpleColor, kPurpleColor.withValues(alpha: 0.0)],
                  stops: const [0.0, 1.0],
                ),
              ),
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                top: kDefaultPadding, // Keep top padding
                bottom: 16, // Reduced bottom padding further from 20 to 16
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your\nproducts',
                    style: kHeadingTextStyle.copyWith(
                      color: kWhiteColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items to your shared shopping cart',
                    style: kBodyTextStyle.copyWith(
                      color: kWhiteColor.withOpacity(0.9), // Use withOpacity
                    ),
                  ),
                ],
              ),
            ),
            // Category filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 8), // Added small vertical padding
              child: SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (ctx, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? kPurpleColor : kFadedPurple,
                          borderRadius: BorderRadius.circular(kButtonBorderRadius),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          category,
                          style: kBodyTextStyle.copyWith(
                            color: isSelected ? kWhiteColor : kPurpleColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Products grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only( // Adjusted padding
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: kDefaultPadding, // Keep bottom padding for FAB spacing
                  top: 4, // Reduced top padding further from 8 to 4
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7, // You might need to adjust this ratio too
                    crossAxisSpacing: 12, // Slightly reduced spacing
                    mainAxisSpacing: 12,  // Slightly reduced spacing
                  ),
                  itemCount: _products.length,
                  itemBuilder: (ctx, i) => _buildProductCard(
                    _products[i], 
                    cartProvider, 
                    userName,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.router.push(const SharedCartRoute());
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text('View Cart'),
        backgroundColor: kPurpleColor,
        foregroundColor: kWhiteColor,
      ),
    );
  }
  
  Widget _buildProductCard(Product product, CartProvider cartProvider, String userName) {
    return Card(
      elevation: 2, // Slightly reduced elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image container
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: kFadedPurple,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(kCardBorderRadius),
                  topRight: Radius.circular(kCardBorderRadius),
                ),
              ),
              width: double.infinity,
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 60,
                  color: kPurpleColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
          
          // Product info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0), // Reduced padding inside card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // This helps distribute space
                children: [
                  Text(
                    product.name,
                    style: kTitleTextStyle.copyWith(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end, // Align items to bottom
                    children: [
                      Flexible( // Wrap price text in Flexible
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: kSubheadingTextStyle.copyWith(
                            color: kPurpleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle potential price overflow
                        ),
                      ),
                      const SizedBox(width: 4), // Add small spacing
                      InkWell(
                        onTap: () {
                          cartProvider.addItem(
                            product.id,
                            product.name,
                            product.price,
                            userName,
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${product.name} to cart'),
                              duration: const Duration(milliseconds: 1500),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  context.router.push(const SharedCartRoute());
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kPurpleColor,
                            borderRadius: BorderRadius.circular(kButtonBorderRadius),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: kWhiteColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}