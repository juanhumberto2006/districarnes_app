import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/paypal_service.dart';
import 'order_confirmation_screen.dart';
import 'paypal_payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0;
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();
  final _notesController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  double get subtotal => cartService.subtotal;
  double get shipping => subtotal > 50000 ? 0 : 3500;
  double get total => subtotal + shipping;

  String _getItemImage(Map<String, dynamic> item) {
    final cachedImageUrl = item['_cachedImageUrl']?.toString();
    if (cachedImageUrl != null && cachedImageUrl.isNotEmpty) return cachedImageUrl;
    
    final imagePath = item['imagen']?.toString() ?? item['imagen_producto']?.toString() ?? '';
    if (imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) return imagePath;
      final fileName = imagePath.split('/').last;
      return '/images/products/$fileName';
    }
    
    final categoryId = item['id_categoria'];
    String categoryKey = 'OTROS';
    if (categoryId != null) {
      if (categoryId == 1 || categoryId.toString() == '1') categoryKey = 'RES';
      else if (categoryId == 2 || categoryId.toString() == '2') categoryKey = 'CERDO';
      else if (categoryId == 3 || categoryId.toString() == '3') categoryKey = 'POLLO';
      else if (categoryId == 4 || categoryId.toString() == '4') categoryKey = 'EMBUTIDOS';
    }
    return _getDefaultImage(categoryKey);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0505),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShippingSection(),
                    _buildPaymentSection(),
                    _buildOrderSummary(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A0F0F),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const Expanded(
            child: Text(
              'FINALIZAR COMPRA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildShippingSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFFE50615), size: 24),
              const SizedBox(width: 8),
              const Text(
                'DIRECCIÓN DE ENTREGA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0F0F),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Column(
              children: [
                _buildInputField('Nombre Completo', 'Tu nombre completo', _nameController),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildInputField('Teléfono', '300 123 4567', _phoneController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInputField('Ciudad', 'Bogotá', _cityController)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInputField('Dirección de Entrega', 'Calle 123 #45-67, Bogotá', _addressController),
                const SizedBox(height: 16),
                _buildInputField('Notas o Instrucciones', 'Por ejemplo: timbre verde, casa blanca...', _notesController, maxLines: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            filled: true,
            fillColor: const Color(0xFF0A0505),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE50615)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payment, color: Color(0xFFE50615), size: 24),
              const SizedBox(width: 8),
              const Text(
                'METODO DE PAGO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(0, 'PayPal', 'Pago seguro con PayPal', '', false),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int index, String name, String detail, String expiry, bool isCard) {
    final isSelected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0F0F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE50615) : Colors.grey.shade800,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: name == 'PayPal' ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  name == 'PayPal' ? 'PP' : name == 'Visa' ? 'VISA' : name == 'Mastercard' ? 'MC' : 'MP',
                  style: TextStyle(
                    color: name == 'Mercado Pago' ? Colors.blue : (name == 'PayPal' ? Colors.white : Colors.black),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isCard)
                    Text(
                      '$detail - Vence $expiry',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    )
                  else
                    Text(
                      detail,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFE50615) : Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0F0F).withOpacity(0.4),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          border: Border(
            top: BorderSide(color: Colors.grey.shade800),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RESUMEN DEL PEDIDO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            // Mostrar productos del carrito
            ...cartService.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final name = item['nombre']?.toString() ?? 'Producto';
              final price = (item['precio_venta'] ?? item['price'] ?? 0).toDouble();
              final quantity = item['quantity'] ?? 1;
              final imageUrl = _getItemImage(item);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[800],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Cantidad: $quantity',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${(price * quantity).toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal (${cartService.itemCount} productos)',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                Text(
                  '\$ ${subtotal.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Envío',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: shipping == 0 ? Colors.green.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    shipping == 0 ? 'GRATIS' : '\$ ${shipping.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: shipping == 0 ? Colors.green : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Color(0xFFE50615)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$ ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFFE50615),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu nombre'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu teléfono'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu dirección'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu ciudad'), backgroundColor: Colors.red),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE50615)),
      ),
    );

    try {
      final orderNumber = 'DC-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      final amountInUsd = total / 4500;

      final result = await payPalService.processPayment(amountInUsd, orderNumber);

      if (!mounted) return;
      Navigator.pop(context);

      if (result['success'] && result['approvalUrl'] != null) {
        final orderData = {
          'items': cartService.items.map((item) => Map<String, dynamic>.from(item)).toList(),
          'subtotal': subtotal,
          'shipping': shipping,
          'total': total,
          'name': _nameController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'notes': _notesController.text,
          'orderNumber': orderNumber,
          'paypalOrderId': result['orderId'],
        };

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PayPalPaymentScreen(
              approvalUrl: result['approvalUrl'],
              orderData: orderData,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${result['message'] ?? "No se pudo crear el pago"}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en el pago: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0505).withOpacity(0.95),
        border: Border(
          top: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _processPayment,
                icon: const Icon(Icons.lock),
                label: const Text(
                  'PAGAR CON PAYPAL',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50615),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user,
                  color: Colors.grey.shade600,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Pago 100% seguro con PayPal',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
