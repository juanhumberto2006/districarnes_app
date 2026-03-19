import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String apiKey = 'YOUR_BREVO_API_KEY';
  static const String mailFrom = 'juanhumbertovega600@gmail.com';
  static const String mailFromName = 'DISTRICARNES HERMANOS NAVARRO';

  Future<bool> sendInvoiceEmail({
    required String toEmail,
    required String customerName,
    required String orderNumber,
    required double total,
    required double subtotal,
    required double shipping,
    required String address,
    required String city,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final htmlContent = _buildInvoiceHtml(
        customerName: customerName,
        orderNumber: orderNumber,
        total: total,
        subtotal: subtotal,
        shipping: shipping,
        address: address,
        city: city,
        items: items,
      );

      final response = await http.post(
        Uri.parse('https://api.brevo.com/v3/smtp/email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'sender': {
            'name': mailFromName,
            'email': mailFrom,
          },
          'to': [
            {
              'email': toEmail,
              'name': customerName,
            }
          ],
          'subject': 'Confirmación de tu pedido #$orderNumber - DISTRICARNES',
          'htmlContent': htmlContent,
        }),
      );

      print('Brevo email response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  String _buildInvoiceHtml({
    required String customerName,
    required String orderNumber,
    required double total,
    required double subtotal,
    required double shipping,
    required String address,
    required String city,
    required List<Map<String, dynamic>> items,
  }) {
    final itemsHtml = items.map((item) {
      final nombre = item['nombre'] ?? 'Producto';
      final cantidad = item['cantidad'] ?? 1;
      final precio = item['precio'] ?? 0.0;
      final subtotalItem = (precio * cantidad).toStringAsFixed(2);
      return '''
        <tr>
          <td style="padding: 12px; border-bottom: 1px solid #333;">$nombre</td>
          <td style="padding: 12px; border-bottom: 1px solid #333; text-align: center;">$cantidad</td>
          <td style="padding: 12px; border-bottom: 1px solid #333; text-align: right;">\$$precio</td>
          <td style="padding: 12px; border-bottom: 1px solid #333; text-align: right;">\$$subtotalItem</td>
        </tr>
      ''';
    }).join('');

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="font-family: Arial, sans-serif; background-color: #0A0505; color: #fff; margin: 0; padding: 20px;">
  <div style="max-width: 600px; margin: 0 auto; background-color: #1A0F0F; border-radius: 12px; overflow: hidden;">
    <div style="background-color: #E50615; padding: 20px; text-align: center;">
      <h1 style="margin: 0; color: #fff; font-size: 24px;">DISTRICARNES</h1>
      <p style="margin: 5px 0 0 0; color: #fff; opacity: 0.9;">HERMANOS NAVARRO</p>
    </div>
    
    <div style="padding: 30px;">
      <h2 style="color: #E50615; margin-top: 0;">¡Gracias por tu compra!</h2>
      <p>Hola <strong>$customerName</strong>,</p>
      <p>Tu pedido ha sido confirmado y está siendo procesado.</p>
      
      <div style="background-color: #2A1F1F; border-radius: 8px; padding: 15px; margin: 20px 0; text-align: center;">
        <p style="margin: 0; color: #888; font-size: 12px;">NÚMERO DE PEDIDO</p>
        <p style="margin: 5px 0 0 0; color: #E50615; font-size: 24px; font-weight: bold;">#$orderNumber</p>
      </div>
      
      <h3 style="color: #fff; border-bottom: 1px solid #333; padding-bottom: 10px;">Detalles del Pedido</h3>
      <table style="width: 100%; border-collapse: collapse; color: #fff;">
        <thead>
          <tr style="color: #888;">
            <th style="padding: 12px; text-align: left;">Producto</th>
            <th style="padding: 12px; text-align: center;">Cant.</th>
            <th style="padding: 12px; text-align: right;">Precio</th>
            <th style="padding: 12px; text-align: right;">Total</th>
          </tr>
        </thead>
        <tbody>
          $itemsHtml
        </tbody>
      </table>
      
      <div style="margin-top: 20px; text-align: right;">
        <p style="color: #888; margin: 5px 0;">Subtotal: <span style="color: #fff;">\$${subtotal.toStringAsFixed(2)}</span></p>
        <p style="color: #888; margin: 5px 0;">Envío: <span style="color: #fff;">${shipping == 0 ? 'GRATIS' : '\$${shipping.toStringAsFixed(2)}'}</span></p>
        <p style="color: #E50615; font-size: 20px; font-weight: bold; margin: 10px 0 0 0;">
          Total: \$${total.toStringAsFixed(2)}
        </p>
      </div>
      
      <h3 style="color: #fff; border-bottom: 1px solid #333; padding-bottom: 10px; margin-top: 30px;">Dirección de Entrega</h3>
      <p style="color: #888;">$address</p>
      <p style="color: #888;">$city</p>
      
      <div style="background-color: #2A1F1F; border-radius: 8px; padding: 15px; margin-top: 30px; text-align: center;">
        <p style="margin: 0; color: #888; font-size: 12px;">Tiempo estimado de entrega</p>
        <p style="margin: 5px 0 0 0; color: #fff; font-size: 18px; font-weight: bold;">45 - 60 minutos</p>
      </div>
      
      <p style="color: #666; font-size: 12px; text-align: center; margin-top: 30px;">
        ¿Tienes alguna pregunta? Contáctanos a través de la app o responde este correo.
      </p>
    </div>
    
    <div style="background-color: #0A0505; padding: 20px; text-align: center;">
      <p style="margin: 0; color: #666; font-size: 11px;">
        © 2024 DISTRICARNES HERMANOS NAVARRO. Todos los derechos reservados.
      </p>
    </div>
  </div>
</body>
</html>
    ''';
  }
}

final emailService = EmailService();
