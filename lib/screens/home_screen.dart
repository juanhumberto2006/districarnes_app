import 'package:flutter/material.dart';
import 'categories_screen.dart';
import 'cart_screen.dart';
import 'offers_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'login_screen.dart';
import '../services/supabase_service.dart';
import '../services/cart_service.dart';
import '../services/image_search_service.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  String _error = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = ['TODOS', 'RES', 'CERDO', 'POLLO', 'EMBUTIDOS'];

  final Map<String, IconData> categoryIcons = {
    'RES': Icons.grass,
    'CERDO': Icons.pets,
    'POLLO': Icons.egg_alt,
    'EMBUTIDOS': Icons.kebab_dining,
    'OTROS': Icons.restaurant,
  };

  final Map<String, String> productImages = {
    'RES': 'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=400&q=80',
    'CERDO': 'https://images.unsplash.com/photo-1606851181064-d6a567a5f8d4?w=400&q=80',
    'POLLO': 'https://images.unsplash.com/photo-1587593810167-a84920ea0781?w=400&q=80',
    'EMBUTIDOS': 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400&q=80',
    'OTROS': 'https://images.unsplash.com/photo-1606850780554-b55d26756aa3?w=400&q=80',
  };

  IconData _getCategoryIcon(String categoryName) {
    final upperName = categoryName.toUpperCase();
    return categoryIcons[upperName] ?? Icons.restaurant;
  }

  String _getProductImageByCategory(String categoryName) {
    final upperName = categoryName.toUpperCase();
    return productImages[upperName] ?? productImages['OTROS']!;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    
    try {
      print('Loading data from Supabase...');
      
      final products = await supabaseService.getProducts();
      final categories = await supabaseService.getCategories();
      
      print('Products loaded: ${products.length}');
      print('Categories loaded: ${categories.length}');
      
      await _loadProductImages(products);
      
      setState(() {
        _products = products;
        _filteredProducts = products;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterProducts() {
    List<Map<String, dynamic>> filtered = List.from(_products);
    
    // Filtrar por categoría
    if (_selectedCategory > 0) {
      final selectedCategoryName = categories[_selectedCategory];
      filtered = filtered.where((product) {
        final categoryId = product['id_categoria'];
        if (categoryId == null) return false;
        
        if (selectedCategoryName == 'RES') return categoryId == 1 || categoryId.toString() == '1';
        if (selectedCategoryName == 'CERDO') return categoryId == 2 || categoryId.toString() == '2';
        if (selectedCategoryName == 'POLLO') return categoryId == 3 || categoryId.toString() == '3';
        if (selectedCategoryName == 'EMBUTIDOS') return categoryId == 4 || categoryId.toString() == '4';
        return true;
      }).toList();
    }
    
    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((product) {
        final name = product['nombre']?.toString().toLowerCase() ?? '';
        final description = product['descripcion']?.toString().toLowerCase() ?? '';
        return name.contains(query) || description.contains(query);
      }).toList();
    }
    
    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _filterProducts();
  }

  Future<void> _loadProductImages(List<Map<String, dynamic>> products) async {
    print('Searching images for products without images...');
    
    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      final imagePath = product['imagen']?.toString() ?? 
                       product['imagen_producto']?.toString() ?? 
                       product['producto_foto']?.toString() ?? '';
      
      if (imagePath.isEmpty) {
        final productName = product['nombre']?.toString() ?? 'Producto';
        final categoryId = product['id_categoria'];
        String categoryName = 'OTROS';
        
        if (categoryId != null) {
          if (categoryId == 1 || categoryId.toString() == '1') categoryName = 'RES';
          else if (categoryId == 2 || categoryId.toString() == '2') categoryName = 'CERDO';
          else if (categoryId == 3 || categoryId.toString() == '3') categoryName = 'POLLO';
          else if (categoryId == 4 || categoryId.toString() == '4') categoryName = 'EMBUTIDOS';
        }
        
        final imageUrl = await imageSearchService.searchImage(productName, categoryName);
        if (imageUrl != null) {
          products[i]['_cachedImageUrl'] = imageUrl;
          print('Found image for $productName: $imageUrl');
        }
      }
    }
    print('Image search completed');
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategory = index;
    });
    _filterProducts();
  }

  void _addToCart(Map<String, dynamic> product) {
    // Verificar si el usuario está logueado
    if (!authService.isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }
    
    final String name = product['nombre']?.toString() ?? 'Producto';
    
    // Agregar al carrito usando el servicio
    cartService.addItem(product);
    cartItemsNotifier.notify();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Añadido al carrito', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(name, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> product) {
    // Verificar si el usuario está logueado
    if (!authService.isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }
    
    final String name = product['nombre']?.toString() ?? 'Producto';
    final productId = product['id_producto'] ?? product['id'] ?? 0;
    
    final isFav = cartService.isFavorite(productId);
    cartService.toggleFavorite(product);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFav ? 'Eliminado de favoritos' : 'Añadido a favoritos'),
        backgroundColor: isFav ? Colors.grey : const Color(0xFFE50615),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
    
    setState(() {});
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A0A0A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Color(0xFFE50615)),
            SizedBox(width: 8),
            Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'Debes iniciar sesión para agregar productos al carrito o favoritos.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50615)),
            child: const Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
        _showMessage('Categorías');
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
        _showMessage('Carrito de compras');
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OffersScreen()));
        _showMessage('Ofertas especiales');
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        _showMessage('Mi cuenta');
        break;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE50615),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSearchTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A0A0A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              const Text('Buscar productos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: '¿Qué buscas?',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              if (_searchQuery.isNotEmpty) ...[
                Text('${_filteredProducts.length} resultados', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _filteredProducts.length > 5 ? 5 : _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      final name = product['nombre']?.toString() ?? 'Producto';
                      return ListTile(
                        leading: const Icon(Icons.search, color: Colors.grey),
                        title: Text(name, style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          _scrollToProduct(index);
                        },
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (_searchQuery.isNotEmpty)
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                  child: const Text('Limpiar búsqueda', style: TextStyle(color: Color(0xFFE50615))),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToProduct(int index) {
    // Los productos se muestran en un scroll, podría implementarse scrollToIndex
  }

  void _onNotificationTap() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
    _showMessage('Notificaciones');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                color: const Color(0xFFE50615),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBanner(),
                      _buildCategories(),
                      _buildProducts(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Color(0xFF1A1A1A))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant, color: Color(0xFFE50615), size: 32),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DISTRICARNES', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                  Text('ONLINE', style: TextStyle(color: const Color(0xFFE50615), fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 3)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(onTap: _onSearchTap, child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.search, color: Colors.white, size: 24),
              )),
              const SizedBox(width: 12),
              GestureDetector(onTap: _onNotificationTap, child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.notifications, color: Colors.white, size: 24),
                  ),
                  Positioned(right: 4, top: 4, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFE50615), shape: BoxShape.circle))),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF1A0A0A), Color(0xFF2D1515)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [BoxShadow(color: const Color(0xFFE50615).withOpacity(0.3), blurRadius: 10)],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20, bottom: -20,
              child: Icon(Icons.restaurant, size: 150, color: const Color(0xFFE50615).withOpacity(0.1)),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFE50615), borderRadius: BorderRadius.circular(20)),
                      child: const Text('OFERTA ESPECIAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: const TextSpan(children: [
                        TextSpan(text: 'OJO DE BIFE\n', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                        TextSpan(text: '20% OFF', style: TextStyle(color: Color(0xFFE50615), fontSize: 22, fontWeight: FontWeight.w900)),
                      ]),
                    ),
                    Text('Calidad premium de exportación', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CATEGORÍAS', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
              GestureDetector(
                onTap: () => _onNavTap(1),
                child: const Text('VER TODAS', style: TextStyle(color: Color(0xFFE50615), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedCategory;
                final catName = categories[index];
                return Padding(
                  padding: EdgeInsets.only(right: index < categories.length - 1 ? 12 : 0),
                  child: GestureDetector(
                    onTap: () => _onCategorySelected(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected 
                              ? [const Color(0xFFE50615), const Color(0xFFB91C1C)]
                              : [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFE50615) : Colors.white.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: const Color(0xFFE50615).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))
                        ] : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(catName, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[300], fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, letterSpacing: 1)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProducts() {
    final String title = _selectedCategory == 0 ? 'CORTES PREMIUM' : '${categories[_selectedCategory]}';
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Row(
                children: [
                  Icon(Icons.grid_view, size: 20, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  const Icon(Icons.view_agenda, size: 20, color: Color(0xFFE50615)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xFFE50615)))
          else if (_error.isNotEmpty)
            Center(
              child: Column(
                children: [
                  Text('Error: $_error', style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50615)),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          else if (_filteredProducts.isEmpty)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No hay productos disponibles', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Total: ${_filteredProducts.length} productos', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50615)),
                    child: const Text('Recargar'),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.65),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) => _buildProductCard(_filteredProducts[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    // Campos de tu base de datos: nombre, precio_venta, imagen, tipo_unidad
    final String name = product['nombre']?.toString() ?? 'Producto';
    
    dynamic priceValue = product['precio_venta'];
    final double price = (priceValue is String) ? double.tryParse(priceValue) ?? 0 : priceValue?.toDouble() ?? 0;
    
    // Buscar imagen cacheada primero
    final cachedImageUrl = product['_cachedImageUrl']?.toString();
    if (cachedImageUrl != null && cachedImageUrl.isNotEmpty) {
      return _buildProductCardWithImage(product, cachedImageUrl, null, price, name);
    }
    
    // Buscar imagen en diferentes campos de la base de datos
    String imagePath = product['imagen']?.toString() ?? 
                       product['imagen_producto']?.toString() ?? 
                       product['producto_foto']?.toString() ?? '';
    
    // Construir la URL completa de la imagen
    String imageUrl = '';
    String? localAssetPath;
    
    if (imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        imageUrl = imagePath;
      } else if (imagePath.startsWith('/')) {
        // Extraer el nombre del archivo de la ruta
        final fileName = imagePath.split('/').last;
        localAssetPath = 'images/products/$fileName';
        // Primero intentar desde carpeta web local, luego desde servidor
        imageUrl = '/images/products/$fileName';
      } else {
        localAssetPath = 'images/products/$imagePath';
        imageUrl = '/images/products/$imagePath';
      }
    } else {
      final categoryId = product['id_categoria'];
      String categoryKey = 'OTROS';
      if (categoryId != null) {
        if (categoryId == 1 || categoryId.toString() == '1') categoryKey = 'RES';
        else if (categoryId == 2 || categoryId.toString() == '2') categoryKey = 'CERDO';
        else if (categoryId == 3 || categoryId.toString() == '3') categoryKey = 'POLLO';
        else if (categoryId == 4 || categoryId.toString() == '4') categoryKey = 'EMBUTIDOS';
      }
      imageUrl = _getProductImageByCategory(categoryKey);
    }
    
    return _buildProductCardWithImage(product, imageUrl, localAssetPath, price, name);
  }

  Widget _buildProductCardWithImage(Map<String, dynamic> product, String imageUrl, String? localAssetPath, double price, String name) {
    final double rating = 4.0;
    final bool hasDiscount = product['precio_descuento'] != null || product['descuento'] != null;
    final String unit = product['tipo_unidad']?.toString() ?? '/ kg';

    // Función para obtener imagen por categoría
    Widget getCategoryImage() {
      final categoryId = product['id_categoria'];
      String categoryKey = 'OTROS';
      if (categoryId != null) {
        if (categoryId == 1 || categoryId.toString() == '1') categoryKey = 'RES';
        else if (categoryId == 2 || categoryId.toString() == '2') categoryKey = 'CERDO';
        else if (categoryId == 3 || categoryId.toString() == '3') categoryKey = 'POLLO';
        else if (categoryId == 4 || categoryId.toString() == '4') categoryKey = 'EMBUTIDOS';
      }
      return Image.network(
        _getProductImageByCategory(categoryKey),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey[800], child: const Icon(Icons.image, color: Colors.grey, size: 40)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        color: Colors.white.withOpacity(0.05),
        boxShadow: [BoxShadow(color: const Color(0xFFE50615).withOpacity(0.3), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover, 
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(color: Colors.grey[800], child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                                color: const Color(0xFFE50615),
                                strokeWidth: 2,
                              ),
                            ));
                          },
                          errorBuilder: (context, error, stackTrace) {
                            // Primero intentar con asset local
                            if (localAssetPath != null && localAssetPath!.isNotEmpty) {
                              return Image.asset(
                                localAssetPath!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  // Luego intentar con URL de producción
                                  final fileName = localAssetPath!.split('/').last;
                                  final prodUrl = 'https://districarnes.onrender.com/static/images/products/$fileName';
                                  return Image.network(
                                    prodUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => getCategoryImage(),
                                  );
                                },
                              );
                            }
                            return getCategoryImage();
                          })
                      : getCategoryImage(),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(product),
                    child: Container(
                      height: 32, 
                      width: 32, 
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5), 
                        shape: BoxShape.circle
                      ),
                      child: Icon(
                        cartService.isFavorite(product['id_producto'] ?? product['id'] ?? 0) 
                            ? Icons.favorite 
                            : Icons.favorite_border, 
                        color: cartService.isFavorite(product['id_producto'] ?? product['id'] ?? 0) 
                            ? Colors.red 
                            : Colors.white, 
                        size: 18
                      ),
                    ),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    bottom: 8, left: 8,
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE50615), borderRadius: BorderRadius.circular(4)), child: const Text('-20%', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900))),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: List.generate(5, (i) => Icon(i < rating.floor() ? Icons.star : Icons.star_border, size: 14, color: i < rating.floor() ? Colors.yellow : Colors.grey[600]))),
                const SizedBox(height: 4),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFE50615), fontSize: 18, fontWeight: FontWeight.w900)),
                    const Spacer(),
                    Text(unit, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _addToCart(product),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50615), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shopping_cart, size: 16), SizedBox(width: 4), Text('AÑADIR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFE50615), boxShadow: [BoxShadow(color: const Color(0xFFE50615).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -5))]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'INICIO', true),
              _buildNavItem(1, Icons.grid_view, 'CATEGORÍAS', false),
              _buildNavItem(2, Icons.shopping_cart, 'CARRITO', false, isCart: true),
              _buildNavItem(3, Icons.sell, 'OFERTAS', false),
              _buildNavItem(4, Icons.person, 'CUENTA', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isActive, {bool isCart = false}) {
    if (isCart) {
      return GestureDetector(
        onTap: () => _onNavTap(index),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(height: 56, width: 56, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)], border: Border.all(color: const Color(0xFFE50615), width: 3)), child: Icon(icon, color: const Color(0xFFE50615), size: 28)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
        ]),
      );
    }
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: isActive ? Colors.white : Colors.white.withOpacity(0.7), size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white.withOpacity(0.7), fontSize: 9, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ]),
    );
  }
}
