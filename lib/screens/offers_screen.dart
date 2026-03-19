import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  int _selectedFilter = 0;

  final List<String> filters = [
    'Todo',
    'Cortes Vacunos',
    'Achuras',
    'Embutidos',
  ];

  final List<Map<String, dynamic>> offerProducts = [
    {
      'name': 'Entraña Premium',
      'price': 38000,
      'originalPrice': 47500,
      'discount': '20% OFF',
      'description': 'Por kilo aprox.',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBJ6qSfXp-7BS3gEeATzEPldEUqG0SPecZ5FP993Mdl75UnQXM6B3qFSUd6SNPviaZJlpbHipc9ShrqOGw9pmTKAL2KMo2QwVRA1qm8g0OGSHnEcHfhNqzdwZV0gjSrM7tKZwNB3KjACvmzpELUe50alSGkKWWqo2aVEpIijwfLnDAl_DMtD2XAZr-xnhG9onuVVeXiOC-WyrhcFXhUyEphwcEQjnVaqCIMxjymQcE7PiL5Q6Sxj4j4JS_RLl3SUjci7z6p5p6rVqQ9',
    },
    {
      'name': 'Chorizos Bombón',
      'price': 15000,
      'originalPrice': 18750,
      'discount': '2x1 Promo',
      'description': 'Pack x 6 unidades',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC_SXCws6wQ6-Y_GTFZJyY1STnHaViCwxesC3lUzfD5c7LLseISsclQaYy9yBHV_',
      'isBlue': true,
    },
    {
      'name': 'Costillar Ahumado',
      'price': 52000,
      'originalPrice': 65000,
      'discount': '20% OFF',
      'description': 'Especial para parrilla',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD8rsvwjR_f6UBwz8Vwuu4yOjP98qqcFg9OGhC4x8TJ9RVD33Oqq0dsK8_C7-pWVSdh7mQv1Pwf7YzkVOWzwjZ5Ebmmja5d8YrLjmS7wT2GBfpszp53XoLRp9Qrwy4T3xAL5KVexwiL2XeHh5CnUN63TRyGfHi1H86uvHJ0BvIRGCQ-BnncgYfeuHRgStWNgSRvBqVsq-GMko-5goVwtZT0fczTfW4YXDlK-S8uiaH-TK1De4Fy_oaveIO1e_7ahDk4hAh0DdD514uY',
    },
    {
      'name': 'Picanha Premium',
      'price': 42500,
      'originalPrice': 50000,
      'discount': '15% OFF',
      'description': 'Corte seleccionado',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuB9m05jTfxnVjmzgMQvfmKn-FlnxbDs7O8nJj7NyEexjJ88emBgr-P6K4bLADKu0woGsZ6QEfqOjj98j0MQfp1IvYprr60zjRCGYYy9KlH5mDW3Cm7arWR191tPq8cabbwVTOx1ExDh_2VKytOeVCLg7Zon10famWGh0J8s3kYiCznvilhIJSGhuvtxXPGw1dLHwr6PavwMSb3wxAZ7vGQ6eegS1-BT2PgeEBEYKcHSTGdr0CiDoLlCI7bNdOVvzcR1h64uSQb9zGaa',
    },
  ];

  void _addToCart(String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName añadido al carrito'),
        backgroundColor: const Color(0xFFE50615),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A0B),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildHeroOffer(),
            _buildFilters(),
            Expanded(
              child: _buildOffersGrid(),
            ),
            _buildPromoBanner(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A0B).withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE50615).withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE50615).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFE50615),
              ),
            ),
          ),
          const Text(
            'DISTRICARNES',
            style: TextStyle(
              color: Color(0xFFE50615),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE50615).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFFE50615),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroOffer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF1A0A0B),
              Colors.transparent,
            ],
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[900],
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBWQnFfXR2HBNcO3c3-LZVzT-IlD8DTNBovBdo_4C4zWTtHXAwo8JFv6tAIf-IaHNlcwHLm8kagZ9k_33RQwBsj3OhnlwetyC6fl_CALD1uwfyiEpg7pRTd0amcwuokyZNyv8Ng86kC_cULWYcvQdhI61nq94P-fwQiJSIcXihdauOGWdVuM2i_7CXPec4p7Drx1qW5xLu8HL0xX4If6cKkFC5DLh209onBGzrWvFNmuXadEzFKThHBtmfBps45raCiJlglByno6Mgl',
                  fit: BoxFit.cover,
                  opacity: AlwaysStoppedAnimation(0.7),
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey[900]);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50615),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'OFERTA DESTACADA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ojo de Bife Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          '\$45.000',
                          style: TextStyle(
                            color: Color(0xFFE50615),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$56.250',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '20% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE50615)
                      : const Color(0xFFE50615).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: const Color(0xFFE50615).withOpacity(0.2),
                        ),
                ),
                alignment: Alignment.center,
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[300],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOffersGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: offerProducts.length,
      itemBuilder: (context, index) {
        final product = offerProducts[index];
        return _buildProductCard(
          name: product['name'],
          price: product['price'],
          originalPrice: product['originalPrice'],
          discount: product['discount'],
          description: product['description'],
          imageUrl: product['imageUrl'],
          isBlue: product['isBlue'] ?? false,
        );
      },
    );
  }

  Widget _buildProductCard({
    required String name,
    required int price,
    required int originalPrice,
    required String discount,
    required String description,
    required String imageUrl,
    bool isBlue = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE50615).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE50615).withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[800],
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isBlue ? Colors.blue : const Color(0xFFE50615),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          color: Color(0xFFE50615),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$$originalPrice',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _addToCart(name),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50615),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Añadir',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE50615), Color(0xFF8B0000)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE50615).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ENVÍO Gratis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'En compras superiores a \$100.000',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.local_shipping,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE50615),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE50615).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home, 'INICIO', 0, false),
              _buildNavItem(context, Icons.grid_view, 'CATEGORÍAS', 1, false),
              _buildCartNavItem(context),
              _buildNavItem(context, Icons.sell, 'OFERTAS', 3, true),
              _buildNavItem(context, Icons.person, 'CUENTA', 4, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            break;
          case 1:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
            break;
          case 4:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartNavItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartScreen()));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
              border: Border.all(color: const Color(0xFFE50615), width: 3),
            ),
            child: const Icon(
              Icons.shopping_cart,
              color: Color(0xFFE50615),
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'CARRITO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
