import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late SupabaseClient _client;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    await Supabase.initialize(
      url: 'https://neyefaqbgrnhwglefabq.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5leWVmYXFiZ3JuaHdnbGVmYWJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIyMDM1ODgsImV4cCI6MjA4Nzc3OTU4OH0.2L2Cod8-jtZKJtiwxZjsvXw_24xYks3p18F4d4qovAM',
    );
    
    _client = Supabase.instance.client;
    _isInitialized = true;
  }

  SupabaseClient get client => _client;

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      if (!_isInitialized) await init();
      
      // Tabla: producto (singular)
      final response = await _client.from('producto').select();
      print('Productos desde Supabase: ${response.length}');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching products: $e');
      return _getDemoProducts();
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      if (!_isInitialized) await init();
      
      // Probar diferentes nombres de tablas
      List<String> tableNames = ['categoria', 'categorias', 'categories', 'category'];
      
      for (var tableName in tableNames) {
        try {
          final response = await _client.from(tableName).select();
          if (response.isNotEmpty) {
            print('Categorías encontradas en: $tableName');
            return List<Map<String, dynamic>>.from(response);
          }
        } catch (e) {
          continue;
        }
      }
      
      return _getDemoCategories();
    } catch (e) {
      print('Error fetching categories: $e');
      return _getDemoCategories();
    }
  }

  Future<List<Map<String, dynamic>>> getOffers() async {
    try {
      final products = await getProducts();
      return products.where((p) => 
        p['discount_price'] != null || 
        p['descuento'] != null ||
        p['descuentos'] != null ||
        p['precio_descuento'] != null
      ).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      if (!_isInitialized) await init();
      
      List<String> tableNames = ['usuario', 'usuarios', 'users', 'user'];
      
      for (var tableName in tableNames) {
        try {
          final response = await _client.from(tableName).select()
            .eq('email', email)
            .eq('password', password)
            .maybeSingle();
          if (response != null) {
            return response;
          }
        } catch (e) {
          continue;
        }
      }
      
      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  Future<bool> registerUser(String name, String email, String password, String phone) async {
    try {
      if (!_isInitialized) await init();
      
      await _client.from('usuario').insert({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  Future<bool> addToCart(Map<String, dynamic> product, int quantity) async {
    try {
      if (!_isInitialized) await init();
      
      await _client.from('carrito').insert({
        'producto_id': product['id'],
        'cantidad': quantity,
        'precio': product['price'] ?? product['precio'],
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> _getDemoProducts() {
    return [
      {
        'id': 1,
        'name': 'Entraña Premium',
        'price': 4200,
        'original_price': 5200,
        'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBy5cnHTpkshzKg3QVqipGTQ0888MhUMY0sfXlCQx689XggEcDOT_oII42UePZW8bEP3dQeHOrlnRmN3bDidcKQPjAgxRHaDVWzPf36QRJYC7NmLS4NhoLY4DZ7GUulJvcMXYJUs0G5F-S4825LFxlpcww7AjTZ8v8ta0ZyhYA2GfTFKoxVAQZkO2M62FaNX956oEvE-zUeTuqA63cXNYZshalHBRgfbF5spqF9L-Shz_A4Ew2Z6w05PaH7I2QNk8rC-L1fONFHxcAs',
        'rating': 5.0,
        'discount_price': 4200,
        'unit': '/ kg',
        'category': 'res'
      },
    ];
  }

  List<Map<String, dynamic>> _getDemoCategories() {
    return [
      {'id': 1, 'name': 'RES', 'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBy5cnHTpkshzKg3QVqipGTQ0888MhUMY0sfXlCQx689XggEcDOT_oII42UePZW8bEP3dQeHOrlnRmN3bDidcKQPjAgxRHaDVWzPf36QRJYC7NmLS4NhoLY4DZ7GUulJvcMXYJUs0G5F-S4825LFxlpcww7AjTZ8v8ta0ZyhYA2GfTFKoxVAQZkO2M62FaNX956oEvE-zUeTuqA63cXNYZshalHBRgfbF5spqF9L-Shz_A4Ew2Z6w05PaH7I2QNk8rC-L1fONFHxcAs'},
    ];
  }

  Future<List<Map<String, dynamic>>> getUserOrders(int userId) async {
    try {
      if (!_isInitialized) await init();
      
      final response = await _client.from('pedido').select()
        .eq('id_usuario', userId)
        .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<bool> createOrder(int userId, double total, String shippingAddress) async {
    return false;
  }

  Future<Map<String, dynamic>?> saveOrder(Map<String, dynamic> orderData) async {
    try {
      if (!_isInitialized) await init();
      
      final response = await _client.from('pedido').insert(orderData).select().maybeSingle();
      return response;
    } catch (e) {
      print('Error saving order: $e');
      return null;
    }
  }

  Future<void> signOut() async {}
}

final supabaseService = SupabaseService();
