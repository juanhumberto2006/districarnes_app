import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/navigation.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Product> _favorites = [];

  void _removeFromFavorites(Product product) {
    setState(() {
      _favorites.remove(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} eliminado de favoritos'),
        backgroundColor: const Color(0xFFE50615),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} añadido al carrito'),
        backgroundColor: const Color(0xFFE50615),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0505),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0505),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mis Favoritos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _favorites.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(),
      bottomNavigationBar: _buildBottomNav(4),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE50615).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 64,
              color: Color(0xFFE50615),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No tienes favoritos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Guarda tus productos favoritos\npara verlos aquí',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => navigateToCategories(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50615),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Explorar Productos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final product = _favorites[index];
        return _buildFavoriteItem(product);
      },
    );
  }

  Widget _buildFavoriteItem(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network(
              product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[800],
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < product.rating.floor() ? Icons.star : Icons.star_border,
                        size: 14,
                        color: index < product.rating.floor() ? Colors.yellow : Colors.grey[600],
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFFE50615),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _removeFromFavorites(product),
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            iconSize: 20,
                          ),
                          IconButton(
                            onPressed: () => _addToCart(product),
                            icon: const Icon(Icons.add_shopping_cart, color: Color(0xFFE50615)),
                            iconSize: 20,
                          ),
                        ],
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

  Widget _buildBottomNav(int currentIndex) {
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
              _buildNavItem(0, Icons.home, 'INICIO'),
              _buildNavItem(1, Icons.grid_view, 'CATEGORÍAS'),
              _buildNavItem(2, Icons.shopping_cart, 'CARRITO'),
              _buildNavItem(3, Icons.sell, 'OFERTAS'),
              _buildNavItem(4, Icons.person, 'CUENTA'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = false;

    if (index == 2) {
      return GestureDetector(
        onTap: () => navigateToCart(context),
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
              child: Icon(icon, color: const Color(0xFFE50615), size: 26),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            navigateToHome(context);
            break;
          case 1:
            navigateToCategories(context);
            break;
          case 3:
            navigateToOffers(context);
            break;
          case 4:
            navigateToProfile(context);
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
