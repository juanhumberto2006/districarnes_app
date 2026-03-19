import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late SupabaseClient _client;
  bool _isInitialized = false;
  
  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> init() async {
    if (_isInitialized) return;
    
    await Supabase.initialize(
      url: 'https://neyefaqbgrnhwglefabq.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5leWVmYXFiZ3JuaHdnbGVmYWJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIyMDM1ODgsImV4cCI6MjA4Nzc3OTU4OH0.2L2Cod8-jtZKJtiwxZjsvXw_24xYks3p18F4d4qovAM',
    );
    
    _client = Supabase.instance.client;
    _isInitialized = true;
    
    // Cargar sesión guardada
    await _loadSession();
  }

  SupabaseClient get client => _client;

  Future<void> _loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        _currentUser = json.decode(userData);
      }
    } catch (e) {
      print('Error loading session: $e');
    }
  }

  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser != null) {
        await prefs.setString('user_data', json.encode(_currentUser));
      } else {
        await prefs.remove('user_data');
      }
    } catch (e) {
      print('Error saving session: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      if (!_isInitialized) await init();
      
      print('Intentando iniciar sesión con: $email');
      
      // Buscar usuario por correo_electronico - especificar campos explícitamente
      Map<String, dynamic>? response;
      
      try {
        final allUsers = await _client.from('usuario').select('id_usuario,nombres_completos,cedula,direccion,celular,correo_electronico,contrasena,rol,usuario_usuario,usuario_foto');
        
        print('Usuarios encontrados: ${allUsers.length}');
        
        for (var user in allUsers) {
          final userEmail = (user['correo_electronico'] ?? '').toString().trim().toLowerCase();
          final userPassword = (user['contrasena'] ?? '').toString();
          
          print('Comparando: email=$email con userEmail=$userEmail, password=$password con userPassword=${userPassword.substring(0, min(20, userPassword.length))}...');
          
          if (userEmail.isNotEmpty && userEmail == email.toLowerCase()) {
            print('Email encontrado: $userEmail');
            
            // Verificar contraseña usando bcrypt
            if (_verifyBcryptPassword(password, userPassword)) {
              response = user;
              print('Login exitoso - contraseña verificada');
              break;
            } else if (userPassword == password) {
              // Contraseña sin encriptar también funciona
              response = user;
              print('Login exitoso - contraseña sin encriptar');
              break;
            } else {
              print('Contraseña incorrecta para $userEmail');
            }
          }
        }
      } catch (e) {
        print('Error en búsqueda: $e');
      }
      
      if (response != null) {
        _currentUser = Map<String, dynamic>.from(response);
        await _saveSession();
        
        await _loadUserFavorites();
        await _loadUserCart();
        
        print('Login exitoso: ${_currentUser?['nombres_completos'] ?? _currentUser?['usuario_usuario']}');
        return true;
      }
      
      print('Usuario no encontrado o contraseña incorrecta');
      return false;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }
  
  bool _verifyBcryptPassword(String plainPassword, String hashedPassword) {
    // El hash en la base de datos es $2y$10$... que es el formato de PHP bcrypt
    // Convertir al formato estándar $2b$ que bcrypt de Dart puede verificar
    
    // 1. Primero intentamos comparación directa (contraseña sin encriptar)
    if (plainPassword == hashedPassword) {
      return true;
    }
    
    // 2. Convertir $2y$ a $2b$ (PHP bcrypt a formato estándar)
    String normalizedHash = hashedPassword;
    if (hashedPassword.startsWith('\$2y\$')) {
      normalizedHash = '\$2b\$' + hashedPassword.substring(4);
    }
    
    // 3. Verificar usando bcrypt
    try {
      final isValid = BCrypt.checkpw(plainPassword, normalizedHash);
      print('Resultado verificación bcrypt: $isValid');
      return isValid;
    } catch (e) {
      print('Error en verificación bcrypt: $e');
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password, String telefono) async {
    try {
      if (!_isInitialized) await init();
      
      // Verificar si el email ya existe
      final allUsers = await _client.from('usuario').select();
      for (var user in allUsers) {
        final userEmail = user['correo_electronico']?.toString().toLowerCase() ?? '';
        if (userEmail == email.toLowerCase()) {
          print('El email ya está registrado');
          return false;
        }
      }
      
      // Crear usuario
      Map<String, dynamic>? response;
      
      try {
        response = await _client.from('usuario').insert({
          'nombres_completos': nombre,
          'correo_electronico': email,
          'contrasena': password,
          'celular': telefono,
          'usuario_usuario': nombre.replaceAll(' ', '').toLowerCase(),
          'created_at': DateTime.now().toIso8601String(),
        }).select().maybeSingle();
      } catch (e) {
        print('Error en registro: $e');
      }
      
      if (response != null) {
        _currentUser = Map<String, dynamic>.from(response);
        await _saveSession();
        print('Registro exitoso: ${_currentUser?['nombres_completos']}');
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error en registro: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _saveSession();
    
    // Limpiar favoritos y carrito local
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_favorites');
    await prefs.remove('user_cart');
    
    print('Sesión cerrada');
  }

  // Favoritos
  List<int> _favorites = [];
  List<int> get favorites => _favorites;

  Future<void> _loadUserFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesData = prefs.getString('user_favorites');
      if (favoritesData != null) {
        _favorites = List<int>.from(json.decode(favoritesData));
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> _saveUserFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_favorites', json.encode(_favorites));
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  Future<void> addToFavorites(int productId) async {
    if (!_favorites.contains(productId)) {
      _favorites.add(productId);
      await _saveUserFavorites();
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    _favorites.remove(productId);
    await _saveUserFavorites();
  }

  bool isFavorite(int productId) {
    return _favorites.contains(productId);
  }

  // Carrito del usuario
  List<Map<String, dynamic>> _userCart = [];
  List<Map<String, dynamic>> get userCart => _userCart;

  Future<void> _loadUserCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('user_cart');
      if (cartData != null) {
        _userCart = List<Map<String, dynamic>>.from(json.decode(cartData));
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  Future<void> _saveUserCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_cart', json.encode(_userCart));
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  Future<void> addToUserCart(Map<String, dynamic> product, int quantity) async {
    // Buscar si el producto ya está en el carrito
    final existingIndex = _userCart.indexWhere((item) => item['id_producto'] == product['id_producto']);
    
    if (existingIndex >= 0) {
      _userCart[existingIndex]['cantidad'] = ((_userCart[existingIndex]['cantidad'] ?? 1) + quantity);
    } else {
      _userCart.add({
        'id_producto': product['id_producto'],
        'nombre': product['nombre'],
        'precio_venta': product['precio_venta'],
        'cantidad': quantity,
        'imagen': product['imagen'],
        'id_categoria': product['id_categoria'],
      });
    }
    
    await _saveUserCart();
  }

  Future<void> removeFromUserCart(int productId) async {
    _userCart.removeWhere((item) => item['id_producto'] == productId);
    await _saveUserCart();
  }

  Future<void> updateUserCartQuantity(int productId, int quantity) async {
    final index = _userCart.indexWhere((item) => item['id_producto'] == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _userCart.removeAt(index);
      } else {
        _userCart[index]['cantidad'] = quantity;
      }
      await _saveUserCart();
    }
  }

  void clearUserCart() {
    _userCart = [];
    _saveUserCart();
  }
}

final authService = AuthService();
