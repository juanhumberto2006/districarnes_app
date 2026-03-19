import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/auth_service.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<Map<String, dynamic>> _items = [];
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get items => _items;
  List<Map<String, dynamic>> get favorites => _favorites;

  void addItem(Map<String, dynamic> product) {
    int existingIndex = -1;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i]['id_producto'] == product['id_producto'] || 
          _items[i]['producto_id'] == product['id_producto']) {
        existingIndex = i;
        break;
      }
    }

    if (existingIndex >= 0) {
      _items[existingIndex]['quantity'] = (_items[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      _items.add({
        ...product,
        'quantity': 1,
      });
    }
    _notifyListeners();
    
    // Guardar en el servicio de autenticación si el usuario está logueado
    if (authService.isLoggedIn) {
      authService.addToUserCart(product, 1);
    }
  }

  void removeItem(int index) {
    final product = _items[index];
    _items.removeAt(index);
    _notifyListeners();
    
    // También eliminar del servidor si está logueado
    if (authService.isLoggedIn && product['id_producto'] != null) {
      authService.removeFromUserCart(product['id_producto']);
    }
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeItem(index);
    } else {
      _items[index]['quantity'] = quantity;
      _notifyListeners();
      
      // Actualizar en el servidor si está logueado
      if (authService.isLoggedIn) {
        final product = _items[index];
        if (product['id_producto'] != null) {
          authService.updateUserCartQuantity(product['id_producto'], quantity);
        }
      }
    }
  }

  void clear() {
    _items.clear();
    _notifyListeners();
    
    if (authService.isLoggedIn) {
      authService.clearUserCart();
    }
  }

  // Favoritos
  bool isFavorite(int productId) {
    return _favorites.any((item) => item['id_producto'] == productId);
  }

  void toggleFavorite(Map<String, dynamic> product) {
    final productId = product['id_producto'];
    final existingIndex = _favorites.indexWhere((item) => item['id_producto'] == productId);
    
    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
      if (authService.isLoggedIn) {
        authService.removeFromFavorites(productId);
      }
    } else {
      _favorites.add(product);
      if (authService.isLoggedIn) {
        authService.addToFavorites(productId);
      }
    }
    _notifyListeners();
  }

  void removeFromFavorites(int productId) {
    _favorites.removeWhere((item) => item['id_producto'] == productId);
    if (authService.isLoggedIn) {
      authService.removeFromFavorites(productId);
    }
    _notifyListeners();
  }

  // Cargar datos del usuario
  Future<void> loadUserData() async {
    if (authService.isLoggedIn) {
      // Cargar carrito del usuario
      _items.clear();
      _items.addAll(authService.userCart);
      
      // Cargar favoritos del usuario
      _favorites.clear();
      for (var favId in authService.favorites) {
        // Necesitamos buscar el producto por ID - esto se hace en la pantalla
      }
      _notifyListeners();
    }
  }

  void clearFavorites() {
    _favorites.clear();
    _notifyListeners();
  }

  double get subtotal {
    double total = 0;
    for (var item in _items) {
      double price = (item['precio_venta'] ?? item['price'] ?? 0).toDouble();
      int qty = item['quantity'] ?? 1;
      total += price * qty;
    }
    return total;
  }

  int get itemCount => _items.length;
  int get favoriteCount => _favorites.length;

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  final List<Function()> _listeners = [];

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }
}

final cartService = CartService();

class CartItemsNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final cartItemsNotifier = CartItemsNotifier();
