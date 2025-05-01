import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
import 'package:shopmate/widgets/animations_widget.dart';
import 'package:shopmate/widgets/responsive_widget.dart';
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
  final List<String> _categories = [
    'All',
    'Electronics',
    'Accessories',
    'Home',
    'Office',
  ];

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
      final price = double.parse(
        (_faker.randomGenerator.decimal(scale: 100, min: 5)).toStringAsFixed(2),
      );

      _products.add(Product(id: id, name: name, price: price));
    }
  }

  String _generateProductName() {
    final productTypes = [
      'Smartphone',
      'Headphones',
      'Laptop',
      'Tablet',
      'Smart Watch',
      'Camera',
      'Speaker',
      'Monitor',
      'Keyboard',
      'Mouse',
      'Charger',
      'Power Bank',
      'USB Cable',
      'Case',
      'Screen Protector',
      'Earbuds',
      'Desk',
      'Lamp',
      'Chair',
      'Backpack',
    ];

    final adjectives = [
      'Premium',
      'Wireless',
      'Ergonomic',
      'Ultra',
      'Pro',
      'Elite',
      'Advanced',
      'Deluxe',
      'Smart',
      'Portable',
      'Compact',
      'High-End',
      'Budget',
      'Luxury',
      'Essential',
    ];

    final brands = [
      'TechPro',
      'Nexus',
      'ZenTech',
      'Fusion',
      'Prime',
      'Alpha',
      'Omega',
      'Vertex',
      'Pinnacle',
      'Echo',
      'Pulse',
      'Element',
    ];

    // Randomly decide whether to use a brand name
    final useBrand = _faker.randomGenerator.boolean();

    if (useBrand) {
      final brand = brands[_faker.randomGenerator.integer(brands.length)];
      final adjective =
          adjectives[_faker.randomGenerator.integer(adjectives.length)];
      final type =
          productTypes[_faker.randomGenerator.integer(productTypes.length)];
      return '$brand $adjective $type';
    } else {
      final adjective =
          adjectives[_faker.randomGenerator.integer(adjectives.length)];
      final type =
          productTypes[_faker.randomGenerator.integer(productTypes.length)];
      return '$adjective $type';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final userName = sessionProvider.currentUserName;
    final isCreator = sessionProvider.isCreator;

    // Wrap the Scaffold with ResponsiveWrapper
    return ResponsiveWrapper(
      phoneBuilder: (context, child) {
        return Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: _buildAppBar(isCreator, cartProvider),
          body: SafeArea(
            child: ResponsiveBuilder(
              builder: (context, sizingInfo) {
                // Use sizing information to adapt layout
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(sizingInfo),
                    _buildCategoryFilter(sizingInfo),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              sizingInfo.screenSize.width < 360
                                  ? kDefaultPadding / 2
                                  : kDefaultPadding,
                          vertical: 4,
                        ),
                        child: _buildProductGrid(
                          sizingInfo,
                          cartProvider,
                          userName,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
      child: Container(),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isCreator, CartProvider cartProvider) {
    return AppBar(
      title: Text(
        isCreator ? 'Products (Creator)' : 'Products (Friend)',
        style: const TextStyle(
          fontFamily: 'Roboto',
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
            PulseAnimation(
              duration: const Duration(milliseconds: 1500),
              minScale: 1.0,
              maxScale: 1.1,
              repeat: true,
              autoStart: cartProvider.itemCount > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart, color: kWhiteColor),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  context.router.push(const SharedCartRoute());
                },
              ),
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
                    style: const TextStyle(color: kWhiteColor, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(SizingInformation sizingInfo) {
    // Adapt text size based on screen width
    final headingSize = sizingInfo.screenSize.width < 360 ? 24.0 : 28.0;
    final bodySize = sizingInfo.screenSize.width < 360 ? 14.0 : 16.0;

    return SlideInAnimation(
      beginOffset: const Offset(0, -0.2),
      duration: const Duration(milliseconds: 600),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kPurpleColor, kPurpleColor.withValues(alpha: 0.0)],
            stops: const [0.0, 1.0],
          ),
        ),
        padding: EdgeInsets.only(
          left: sizingInfo.screenSize.width < 360 ? 16.0 : kDefaultPadding,
          right: sizingInfo.screenSize.width < 360 ? 16.0 : kDefaultPadding,
          top: kDefaultPadding,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your\nproducts',
              style: kHeadingTextStyle.copyWith(
                color: kWhiteColor,
                height: 1.2,
                fontSize: headingSize,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap on items to add them to your cart',
              style: kBodyTextStyle.copyWith(
                color: kWhiteColor.withValues(alpha: 0.9),
                fontSize: bodySize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(SizingInformation sizingInfo) {
    // Adjust height and padding based on screen size
    final categoryHeight = sizingInfo.screenSize.width < 360 ? 36.0 : 40.0;

    return SlideInAnimation(
      beginOffset: const Offset(-0.2, 0),
      duration: const Duration(milliseconds: 700),
      delay: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              sizingInfo.screenSize.width < 360 ? 16.0 : kDefaultPadding,
          vertical: 8,
        ),
        child: SizedBox(
          height: categoryHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (ctx, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;

              // Apply staggered animations to category items
              return SlideInAnimation(
                beginOffset: const Offset(0.2, 0),
                duration: Duration(milliseconds: 400 + (index * 100)),
                delay: true,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          sizingInfo.screenSize.width < 360 ? 16.0 : 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? kPurpleColor : kFadedPurple,
                      borderRadius: BorderRadius.circular(kButtonBorderRadius),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: kBodyTextStyle.copyWith(
                        color: isSelected ? kWhiteColor : kPurpleColor,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize:
                            sizingInfo.screenSize.width < 360 ? 13.0 : 14.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(
    SizingInformation sizingInfo,
    CartProvider cartProvider,
    String userName,
  ) {
    // Adapt grid properties based on screen size
    final crossAxisCount = sizingInfo.screenSize.width < 600 ? 2 : 3;
    final aspectRatio = sizingInfo.screenSize.width < 360 ? 0.65 : 0.725;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: sizingInfo.screenSize.width < 360 ? 8 : 12,
        mainAxisSpacing: sizingInfo.screenSize.width < 360 ? 8 : 12,
      ),
      itemCount: _products.length,
      itemBuilder:
          (ctx, i) => SlideInAnimation(
            // Apply staggered animation to grid items
            beginOffset: const Offset(0, 0.25),
            duration: Duration(milliseconds: 450 + (i % 4) * 150),
            delay: true,
            curve: Curves.easeOutQuart,
            child: _buildProductCard(
              _products[i],
              cartProvider,
              userName,
              sizingInfo,
            ),
          ),
    );
  }

  Widget _buildProductCard(
    Product product,
    CartProvider cartProvider,
    String userName,
    SizingInformation sizingInfo,
  ) {
    // Adapt text sizes based on screen width
    final titleSize = sizingInfo.screenSize.width < 360 ? 12.0 : 14.0;
    final priceSize = sizingInfo.screenSize.width < 360 ? 14.0 : 16.0;
    final iconSize = sizingInfo.screenSize.width < 360 ? 50.0 : 60.0;

    return InkWell(
      onTap: () {
        cartProvider.addItem(product.id, product.name, product.price, userName);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${product.name} to cart'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          ),
        );
      },
      child: Card(
        elevation: 2,
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
                    size: iconSize,
                    color: kPurpleColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),

            // Product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: kTitleTextStyle.copyWith(fontSize: titleSize),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: kSubheadingTextStyle.copyWith(
                        color: kPurpleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: priceSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
