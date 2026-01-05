import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class OdooClient {
  static final OdooClient _instance = OdooClient._internal();
  factory OdooClient() => _instance;
  OdooClient._internal();

  final _storage = const FlutterSecureStorage();
  final String baseUrl = "odoo-instance.com";
  final String db = "database_name";

  // Cache session info
  String? _sessionId;
  int? _uid;

  /// --- AUTHENTICATION SERVICE ---
  /// Communicates with Odoo /web/session/authenticate
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/web/session/authenticate');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "params": {
            "db": db,
            "login": username,
            "password": password,
          }
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['result'] != null) {
          _uid = body['result']['uid'];
          _sessionId = body['result']['session_id'];

          await _storage.write(key: 'session_id', value: _sessionId);
          await _storage.write(key: 'uid', value: _uid.toString());
          
          return body['result'];
        }
      }
      return null;
    } catch (e) {
      print("Auth Error: $e");
      return null;
    }
  }

  /// --- DATA RETRIEVAL SERVICE (execute_kw) ---
  /// Generic method to call any Odoo model method
  Future<dynamic> callKw({
    required String model,
    required String method,
    required List args,
    Map kwargs = const {},
  }) async {
    final url = Uri.parse('$baseUrl/jsonrpc');
    
    // Retrieve session from storage if cached version is null
    _sessionId ??= await _storage.read(key: 'session_id');

    final payload = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [db, _uid, 'password_or_token', model, method, args, kwargs],
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$_sessionId',
        },
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      return data['result'];
    } catch (e) {
      print("Odoo RPC Error: $e");
      return null;
    }
  }
}

class FinancialService {
  final OdooClient _client = OdooClient();

  /// Maps Odoo account.analytic.account to Dashboard Assets
  Future<List<Map<String, dynamic>>> getDashboardAssets() async {
    final result = await _client.callKw(
      model: 'account.analytic.account',
      method: 'search_read',
      args: [
        [['code', 'ilike', 'SALIO']] 
      ],
      kwargs: {
        'fields': ['name', 'balance', 'code'],
      },
    );

    if (result == null) return [];

    // Map Odoo results to Flutter UI Map
    return List<Map<String, dynamic>>.from(result.map((item) => {
      'name': item['name'],
      'amount': (item['balance'] as num).toInt(),
      'icon': _getIconForCode(item['code']),
      'route': _getRouteForCode(item['code']),
    }));
  }

  /// Maps Odoo account.move to Dashboard Debts
  Future<int> getTotalDebt() async {
    final result = await _client.callKw(
      model: 'account.move',
      method: 'read_group',
      args: [
        [['move_type', '=', 'out_invoice'], ['payment_state', '!=', 'paid']]
      ],
      kwargs: {
        'fields': ['amount_residual'],
        'groupby': [],
      },
    );

    if (result != null && result.isNotEmpty) {
      return (result[0]['amount_residual'] as num).toInt();
    }
    return 0;
  }

  // Helper logic to maintain UI routes defined in your UI code
  String _getRouteForCode(String code) {
    if (code.contains('HISA')) return '/salio_hisa';
    if (code.contains('AKIB')) return '/salio_akiba';
    return '/salio_details';
  }

  // Helper for UI icons
  dynamic _getIconForCode(String code) {
    // Logic to return Icons.trending_up etc
  }
}