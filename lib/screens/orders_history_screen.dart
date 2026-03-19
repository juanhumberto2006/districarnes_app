import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import 'home_screen.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  int _selectedTab = 0;
  List<Map<String, dynamic>> _activeOrders = [];
  List<Map<String, dynamic>> _completedOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = authService.currentUser?['id_usuario'];
      print('Cargando pedidos para usuario: $userId');

      if (userId != null) {
        final response = await supabaseService.client
            .from('pedido')
            .select()
            .eq('id_usuario', userId)
            .order('created_at', ascending: false);

        print('Pedidos encontrados: ${response.length}');

        final allOrders = List<Map<String, dynamic>>.from(response);

        final active = allOrders.where((order) {
          final estado = order['estado_pedido']?.toString().toLowerCase() ?? '';
          return estado == 'pendiente' || estado == 'preparando' || estado == 'enviado' || estado == 'en camino';
        }).toList();

        final completed = allOrders.where((order) {
          final estado = order['estado_pedido']?.toString().toLowerCase() ?? '';
          return estado == 'entregado' || estado == 'completado' || estado == 'cancelado';
        }).toList();

        setState(() {
          _activeOrders = active;
          _completedOrders = completed;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando pedidos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0505),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: _selectedTab == 0 ? _buildActiveOrders() : _buildCompletedOrders(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE50615).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Mis Pedidos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTab == 0 ? const Color(0xFFE50615) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'En curso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedTab == 0 ? const Color(0xFFE50615) : const Color(0xFFBB9B9D),
                    fontSize: 14,
                    fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTab == 1 ? const Color(0xFFE50615) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Completados',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedTab == 1 ? const Color(0xFFE50615) : const Color(0xFFBB9B9D),
                    fontSize: 14,
                    fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrders() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE50615)),
      );
    }

    if (_activeOrders.isEmpty) {
      return _buildEmptyState('No tienes pedidos activos');
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: const Color(0xFFE50615),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PEDIDOS ACTIVOS',
              style: TextStyle(
                color: Color(0xFFBB9B9D),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            ..._activeOrders.map((order) => _buildActiveOrderCard(order)),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedOrders() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE50615)),
      );
    }

    if (_completedOrders.isEmpty) {
      return _buildEmptyState('No tienes pedidos completados');
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: const Color(0xFFE50615),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'HISTORIAL RECIENTE',
              style: TextStyle(
                color: Color(0xFFBB9B9D),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            ..._completedOrders.map((order) => _buildCompletedOrderCard(order)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey.shade700,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50615),
            ),
            child: const Text('Ir a comprar'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderCard(Map<String, dynamic> order) {
    final orderNumber = order['numero_pedido'] ?? 'DC-000';
    final estado = order['estado_pedido']?.toString() ?? 'pendiente';
    final items = order['items'] as List<dynamic>? ?? [];
    final createdAt = order['created_at'] != null 
        ? DateTime.tryParse(order['created_at'].toString()) 
        : null;
    
    String dateStr = '';
    if (createdAt != null) {
      dateStr = '${createdAt.day} ${_getMonthName(createdAt.month)}, ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
    }

    String statusText = 'En proceso';
    Color statusColor = Colors.orange;
    if (estado.toLowerCase() == 'pendiente') {
      statusText = 'Pendiente';
      statusColor = Colors.orange;
    } else if (estado.toLowerCase() == 'preparando') {
      statusText = 'Preparando';
      statusColor = Colors.blue;
    } else if (estado.toLowerCase() == 'enviado' || estado.toLowerCase() == 'en camino') {
      statusText = 'En camino';
      statusColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F0F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE50615).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE50615).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE50615).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PEDIDO ACTIVO',
                            style: TextStyle(
                              color: Color(0xFFE50615),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#$orderNumber',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$dateStr - ${items.length} productos',
                          style: TextStyle(
                            color: const Color(0xFFBB9B9D),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrdersHistoryScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50615),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Ver Detalle',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedOrderCard(Map<String, dynamic> order) {
    final orderNumber = order['numero_pedido'] ?? 'DC-000';
    final total = (order['total'] ?? 0).toDouble();
    final estado = order['estado_pedido']?.toString() ?? 'completado';
    final items = order['items'] as List<dynamic>? ?? [];
    final createdAt = order['created_at'] != null 
        ? DateTime.tryParse(order['created_at'].toString()) 
        : null;
    
    String dateStr = '';
    if (createdAt != null) {
      dateStr = '${createdAt.day} ${_getMonthName(createdAt.month)}, ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
    }

    String statusText = 'Entregado';
    Color statusColor = Colors.grey;
    if (estado.toLowerCase() == 'entregado' || estado.toLowerCase() == 'completado') {
      statusText = 'Entregado';
      statusColor = Colors.green;
    } else if (estado.toLowerCase() == 'cancelado') {
      statusText = 'Cancelado';
      statusColor = Colors.red;
    }

    String firstProduct = 'Productos';
    if (items.isNotEmpty) {
      firstProduct = items.first['nombre']?.toString() ?? 'Producto';
      if (items.length > 1) {
        firstProduct += ' +${items.length - 1} más';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F0F).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade800,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#$orderNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$dateStr - ${items.length} prod',
                    style: TextStyle(
                      color: const Color(0xFFBB9B9D),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[800],
                ),
                child: const Icon(Icons.restaurant, color: Color(0xFFE50615)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstProduct,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Color(0xFFE50615),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersHistoryScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE50615)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ver',
                  style: TextStyle(
                    color: Color(0xFFE50615),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return months[month - 1];
  }
}
