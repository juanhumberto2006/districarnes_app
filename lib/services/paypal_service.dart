import 'dart:convert';
import 'package:http/http.dart' as http;

class PayPalService {
  static const String clientId = 'AXmQDD-XaDYP0p91YTznhmVRRWm7a7_3jFUrBc0LS_MGAYJApVLcT_qbCuP1nRym-pKukzyd9AoW5zbT';
  static const String clientSecret = 'EMeRSfEwJQ7HlMsGdUbCCIKKhi29bmMOh1cJmTX_3CrPjUICeqiUik1ofoXLVqEQej2c5Ygg3tlzsgHB';
  static const String baseUrl = 'https://api-m.sandbox.paypal.com';
  
  String? _accessToken;

  Future<String> getAccessToken() async {
    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));
    
    final response = await http.post(
      Uri.parse('$baseUrl/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _accessToken = data['access_token'];
      return _accessToken!;
    } else {
      throw Exception('Failed to get access token: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createOrder(double amount, String orderNumber) async {
    try {
      final accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('$baseUrl/v2/checkout/orders'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'intent': 'CAPTURE',
          'purchase_units': [
            {
              'reference_id': orderNumber,
              'amount': {
                'currency_code': 'USD',
                'value': amount.toStringAsFixed(2),
              },
              'description': 'Pedido Districarnes - $orderNumber',
            }
          ],
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        
        String approvalUrl = '';
        String paypalOrderId = data['id'];
        
        for (var link in data['links']) {
          if (link['rel'] == 'approve') {
            approvalUrl = link['href'];
            break;
          }
        }
        
        return {
          'success': true,
          'orderId': paypalOrderId,
          'approvalUrl': approvalUrl,
        };
      } else {
        return {
          'success': false,
          'orderId': null,
          'approvalUrl': null,
          'message': 'Error al crear la orden: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'orderId': null,
        'approvalUrl': null,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> captureOrder(String orderId) async {
    try {
      final accessToken = await getAccessToken();

      final response = await http.post(
        Uri.parse('$baseUrl/v2/checkout/orders/$orderId/capture'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        
        String? payerEmail;
        if (data['purchase_units'] != null && 
            data['purchase_units'].isNotEmpty &&
            data['purchase_units'][0]['payments'] != null &&
            data['purchase_units'][0]['payments']['captures'] != null &&
            data['purchase_units'][0]['payments']['captures'].isNotEmpty) {
          payerEmail = data['purchase_units'][0]['payments']['captures'][0]['custom_id'];
        }
        
        return {
          'success': data['status'] == 'COMPLETED',
          'status': data['status'],
          'payerEmail': payerEmail,
        };
      } else {
        return {
          'success': false,
          'message': 'Error al capturar el pago: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> processPayment(double amount, String orderNumber) async {
    return await createOrder(amount, orderNumber);
  }
}

final payPalService = PayPalService();
