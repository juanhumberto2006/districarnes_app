import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/paypal_service.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../services/email_service.dart';
import 'order_confirmation_screen.dart';

class PayPalPaymentScreen extends StatefulWidget {
  final String approvalUrl;
  final Map<String, dynamic> orderData;
  
  const PayPalPaymentScreen({
    super.key,
    required this.approvalUrl,
    required this.orderData,
  });

  @override
  State<PayPalPaymentScreen> createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;
  bool _paymentCaptured = false;
  String _paypalOrderId = '';
  Timer? _paymentCheckTimer;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _paypalOrderId = widget.orderData['paypalOrderId'] ?? '';
    _initWebView();
    _startPaymentCheckTimer();
  }

  @override
  void dispose() {
    _paymentCheckTimer?.cancel();
    super.dispose();
  }

  void _startPaymentCheckTimer() {
    _paymentCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_paymentCaptured && _paypalOrderId.isNotEmpty) {
        _checkPaymentStatus();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _checkPaymentStatus() async {
    if (_paypalOrderId.isEmpty || _paymentCaptured) return;
    
    try {
      final captureResult = await payPalService.captureOrder(_paypalOrderId);
      
      if (captureResult['success'] || captureResult['status'] == 'COMPLETED') {
        setState(() {
          _paymentCaptured = true;
        });
        _paymentCheckTimer?.cancel();
        await _capturePayment();
      }
    } catch (e) {
      print('Error checking payment: $e');
    }
  }
  
  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A0505))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            print('Page started: $url');
            
            // Check for PayPal completion indicators in URL
            if (_shouldCompletePayment(url)) {
              _onPaymentApproved();
            } else if (url.contains('cancel') || url.contains('canceled')) {
              _onPaymentCancelled();
            }
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            print('Page finished: $url');
            
            // Check URL when page finishes loading
            if (_shouldCompletePayment(url)) {
              _onPaymentApproved();
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            setState(() {
              _isLoading = false;
              _errorMessage = error.description;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  bool _shouldCompletePayment(String url) {
    // Check various PayPal return URL patterns
    return url.contains('payment-success') ||
           url.contains('success') ||
           url.contains('complete') ||
           url.contains('approved') ||
           url.contains('return') && !url.contains('cancel');
  }

  void _onPaymentApproved() {
    if (!_paymentCaptured) {
      setState(() {
        _paymentCaptured = true;
      });
      _paymentCheckTimer?.cancel();
      _capturePayment();
    }
  }

  void _onPaymentCancelled() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pago cancelado'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _saveOrderToDatabase() async {
    try {
      final orderNumber = widget.orderData['orderNumber'] ?? 'DC-${DateTime.now().millisecondsSinceEpoch}';
      final items = widget.orderData['items'] as List<dynamic>? ?? [];
      final total = widget.orderData['total'] as double? ?? 0.0;
      final subtotal = widget.orderData['subtotal'] as double? ?? 0.0;
      final shipping = widget.orderData['shipping'] as double? ?? 0.0;
      final name = widget.orderData['name'] as String? ?? '';
      final address = widget.orderData['address'] as String? ?? '';
      final city = widget.orderData['city'] as String? ?? '';
      final phone = widget.orderData['phone'] as String? ?? '';
      
      final userId = authService.currentUser?['id_usuario'];
      print('Guardando pedido - UserID: $userId, Order: $orderNumber');
      
      final itemsJson = items.map((item) => {
        'id_producto': item['id_producto'],
        'nombre': item['nombre'],
        'precio': item['precio_venta'],
        'cantidad': item['quantity'] ?? 1,
      }).toList();
      
      final insertData = {
        'id_usuario': userId,
        'numero_pedido': orderNumber,
        'total': total,
        'subtotal': subtotal,
        'envio': shipping,
        'estado': 'pagado',
        'metodo_pago': 'PayPal',
        'paypal_order_id': _paypalOrderId,
        'direccion': address,
        'ciudad': city,
        'telefono': phone,
        'nombre_cliente': name,
        'items': itemsJson,
        'estado_pedido': 'pendiente',
      };
      
      print('Datos a guardar: $insertData');
      
      await supabaseService.client.from('pedido').insert(insertData);
      
      print('Pedido guardado exitosamente: $orderNumber');
    } catch (e) {
      print('Error al guardar pedido: $e');
    }
  }

  Future<void> _processSuccessfulPayment() async {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE50615)),
      ),
    );
    
    try {
      await _saveOrderToDatabase();
      
      await _sendInvoiceEmail();
      
      if (!mounted) return;
      Navigator.pop(context);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            orderData: widget.orderData,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      await _sendInvoiceEmail();
      
      Navigator.pop(context);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            orderData: widget.orderData,
          ),
        ),
      );
    }
  }
  
  Future<void> _sendInvoiceEmail() async {
    try {
      final userEmail = authService.currentUser?['correo_electronico'];
      final userName = widget.orderData['name'] as String? ?? '';
      final orderNumber = widget.orderData['orderNumber'] ?? 'DC-${DateTime.now().millisecondsSinceEpoch}';
      final items = widget.orderData['items'] as List<dynamic>? ?? [];
      final total = widget.orderData['total'] as double? ?? 0.0;
      final subtotal = widget.orderData['subtotal'] as double? ?? 0.0;
      final shipping = widget.orderData['shipping'] as double? ?? 0.0;
      final address = widget.orderData['address'] as String? ?? '';
      final city = widget.orderData['city'] as String? ?? '';
      
      if (userEmail != null && userEmail.isNotEmpty) {
        final itemsList = items.map((item) => {
          'nombre': item['nombre'] ?? 'Producto',
          'cantidad': item['quantity'] ?? 1,
          'precio': item['precio_venta'] ?? item['price'] ?? 0.0,
        }).toList();
        
        await emailService.sendInvoiceEmail(
          toEmail: userEmail,
          customerName: userName,
          orderNumber: orderNumber.toString(),
          total: total,
          subtotal: subtotal,
          shipping: shipping,
          address: address,
          city: city,
          items: List<Map<String, dynamic>>.from(itemsList),
        );
        
        print('Factura enviada a: $userEmail');
      }
    } catch (e) {
      print('Error al enviar correo: $e');
    }
  }
  
  Future<void> _capturePayment() async {
    if (_paypalOrderId.isEmpty) {
      _paypalOrderId = widget.orderData['paypalOrderId'] ?? '';
    }
    
    if (_paypalOrderId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No se encontró la orden de PayPal'),
          backgroundColor: Colors.red,
        ),
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
      final captureResult = await payPalService.captureOrder(_paypalOrderId);
      
      if (!mounted) return;
      Navigator.pop(context);
      
      print('Capture result: $captureResult');
      
      await _processSuccessfulPayment();
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      
      print('Error capturing payment: $e');
      
      await _processSuccessfulPayment();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0A0505),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0505),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1A0F0F),
                title: const Text('¿Cancelar pago?', style: TextStyle(color: Colors.white)),
                content: const Text(
                  '¿Estás seguro de que quieres cancelar el pago?',
                  style: TextStyle(color: Colors.grey),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No', style: TextStyle(color: Color(0xFFE50615))),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Sí, cancelar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        ),
        title: const Text(
          'Pago con PayPal',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_paymentCaptured)
            Container(
              color: const Color(0xFF0A0505),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'PAGO COMPLETADO',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Redireccionando...',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(color: Color(0xFFE50615)),
                  ],
                ),
              ),
            )
          else if (_isLoading)
            Container(
              color: const Color(0xFF0A0505),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFE50615)),
                    SizedBox(height: 16),
                    Text(
                      'Conectando con PayPal...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          if (_errorMessage != null && !_isLoading)
            Container(
              color: const Color(0xFF0A0505),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFE50615), size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $_errorMessage',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isLoading = true;
                        });
                        _controller.reload();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50615),
                      ),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }
}
