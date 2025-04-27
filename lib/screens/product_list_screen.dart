import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
import '../providers/cart_provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../models/product.dart';

@RoutePage()
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> _products = [];
  final _faker = Faker();
  
  @override
  void initState() {
    super.initState();
    _generateProducts();
  }
  
  void _generateProducts() {
    // Generate 15 random products using Faker
    for (int i = 0; i < 15; i++) {
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
      appBar: AppBar(
        title: Text(isCreator ? 'Products (Creator)' : 'Products (Friend)'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
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
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2/3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (ctx, i) => _buildProductItem(
          _products[i], 
          cartProvider, 
          userName,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.router.push(const SharedCartRoute());
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text('View Cart'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
  
  Widget _buildProductItem(Product product, CartProvider cartProvider, String userName) {
    return Card(
      elevation: 2,
      child: InkWell(
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
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'VIEW CART',
                onPressed: () {
                  context.router.push(const SharedCartRoute());
                },
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Center(
                  // Using placeholder instead of actual image
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
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
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
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