import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'offers_screen.dart';
import 'profile_screen.dart';
import 'checkout_screen.dart';
import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    cartItemsNotifier.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    cartItemsNotifier.removeListener(_updateState);
    super.dispose();
  }

  double get subtotal => cartService.subtotal;
  double get shipping => subtotal > 50000 ? 0 : 3500;
  double get total => subtotal + shipping;

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
        title: const Text('Mi Carrito', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: cartService.items.isEmpty
          ? _buildEmptyCart()
          : _buildCartContent(),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildEmptyCart() {
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
            child: const Icon(Icons.shopping_cart_outlined, size: 64, color: Color(0xFFE50615)),
          ),
          const SizedBox(height: 24),
          const Text('Tu carrito está vacío', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Agrega productos para comenzar', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50615), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
            child: const Text('Explorar Productos'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartService.items.length,
            itemBuilder: (context, index) {
              return _buildCartItem(index);
            },
          ),
        ),
        _buildSummary(),
      ],
    );
  }

  Widget _buildCartItem(int index) {
    final item = cartService.items[index];
    final String name = item['nombre']?.toString() ?? item['name']?.toString() ?? 'Producto';
    final double price = (item['precio_venta'] ?? item['price'] ?? 0).toDouble();
    int quantity = item['quantity'] ?? 1;

    // Get image URL - try multiple field names
    String imageUrl = '';
    
    // Try cached image first
    final cachedImageUrl = item['_cachedImageUrl']?.toString();
    if (cachedImageUrl != null && cachedImageUrl.isNotEmpty) {
      imageUrl = cachedImageUrl;
    }
    
    // Try multiple possible image field names
    if (imageUrl.isEmpty) {
      final imageFields = ['imagen', 'imagen_producto', 'producto_foto', 'foto', 'url_imagen', 'imagen_url', 'image', 'image_url'];
      for (final field in imageFields) {
        final imagePath = item[field]?.toString();
        if (imagePath != null && imagePath.isNotEmpty) {
          if (imagePath.startsWith('http')) {
            imageUrl = imagePath;
            break;
          } else if (imagePath.startsWith('/')) {
            imageUrl = 'https://neyefaqbgrnhwglefabq.supabase.co/storage/v1/object/public/images${imagePath}';
            break;
          } else {
            imageUrl = 'https://neyefaqbgrnhwglefabq.supabase.co/storage/v1/object/public/images/products/$imagePath';
            break;
          }
        }
      }
    }

    // If still no image, use category-based default
    if (imageUrl.isEmpty) {
      final categoryId = item['id_categoria'];
      String categoryKey = 'OTROS';
      if (categoryId != null) {
        if (categoryId == 1 || categoryId.toString() == '1') categoryKey = 'RES';
        else if (categoryId == 2 || categoryId.toString() == '2') categoryKey = 'CERDO';
        else if (categoryId == 3 || categoryId.toString() == '3') categoryKey = 'POLLO';
        else if (categoryId == 4 || categoryId.toString() == '4') categoryKey = 'EMBUTIDOS';
      }
      imageUrl = _getDefaultImage(categoryKey);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isNotEmpty
                ? Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover, 
                    errorBuilder: (_, __, ___) {
                      final categoryId = item['id_categoria'];
                      String categoryKey = 'OTROS';
                      if (categoryId != null) {
                        if (categoryId == 1 || categoryId.toString() == '1') categoryKey = 'RES';
                        else if (categoryId == 2 || categoryId.toString() == '2') categoryKey = 'CERDO';
                        else if (categoryId == 3 || categoryId.toString() == '3') categoryKey = 'POLLO';
                        else if (categoryId == 4 || categoryId.toString() == '4') categoryKey = 'EMBUTIDOS';
                      }
                      return Image.network(_getDefaultImage(categoryKey), width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder());
                    })
                : _buildPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2),
                const SizedBox(height: 4),
                Text('\$${price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFE50615), fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildQuantityButton(Icons.remove, () {
                      if (quantity > 1) {
                        cartService.updateQuantity(index, quantity - 1);
                        setState(() {});
                      } else {
                        cartService.removeItem(index);
                        setState(() {});
                      }
                    }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    _buildQuantityButton(Icons.add, () {
                      cartService.updateQuantity(index, quantity + 1);
                      setState(() {});
                    }),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              cartService.removeItem(index);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name eliminado'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80, height: 80,
      color: Colors.grey[800],
      child: const Icon(Icons.image, color: Colors.grey, size: 40),
    );
  }

  String _getDefaultImage(String category) {
    final Map<String, String> defaultImages = {
      'RES': 'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=400&q=80',
      'CERDO': 'https://images.unsplash.com/photo-1606851181064-d6a567a5f8d4?w=400&q=80',
      'POLLO': 'https://images.unsplash.com/photo-1587593810167-a84920ea0781?w=400&q=80',
      'EMBUTIDOS': 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400&q=80',
      'OTROS': 'https://images.unsplash.com/photo-1606850780554-b55d26756aa3?w=400&q=80',
    };
    return defaultImages[category] ?? defaultImages['OTROS']!;
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFE50615), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A0A),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Subtotal', style: TextStyle(color: Colors.grey)),
              Text('\$${subtotal.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Envío', style: TextStyle(color: Colors.grey)),
              Text(shipping == 0 ? 'GRATIS' : '\$${shipping.toStringAsFixed(0)}', style: TextStyle(color: shipping == 0 ? Colors.green : Colors.white)),
            ]),
            const Divider(color: Colors.white24, height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Total', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('\$${total.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFE50615), fontSize: 24, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50615), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('REALIZAR PEDIDO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFE50615), boxShadow: [BoxShadow(color: const Color(0xFFE50615).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -5))]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'INICIO'),
              _buildNavItem(context, 1, Icons.grid_view, 'CATEGORÍAS'),
              _buildNavItem(context, 2, Icons.shopping_cart, 'CARRITO', isActive: true),
              _buildNavItem(context, 3, Icons.sell, 'OFERTAS'),
              _buildNavItem(context, 4, Icons.person, 'CUENTA'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, {bool isActive = false}) {
    if (index == 2) {
      return GestureDetector(
        onTap: () {},
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(height: 52, width: 52, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE50615), width: 3)), child: Stack(
            children: [
              Center(child: Icon(icon, color: const Color(0xFFE50615), size: 26)),
              if (cartService.itemCount > 0)
                Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Text('${cartService.itemCount}', style: const TextStyle(color: Color(0xFFE50615), fontSize: 10, fontWeight: FontWeight.bold)))),
            ],
          )),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
        ]),
      );
    }
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())); break;
          case 1: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CategoriesScreen())); break;
          case 3: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OffersScreen())); break;
          case 4: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen())); break;
        }
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: isActive ? Colors.white : Colors.white.withOpacity(0.7), size: 24),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white.withOpacity(0.7), fontSize: 8, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ]),
    );
  }
}
