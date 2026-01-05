import 'dart:convert';
import 'package:http/http.dart' as http;

class OdooService {
  final String url;
  final String db;
  final String username;
  final String password;
  
  int? _uid;
  String? _sessionId;

  OdooService({
    required this.url,
    required this.db,
    required this.username,
    required this.password,
  });

  Future<bool> authenticate() async {
    final response = await http.post(
      Uri.parse('$url/jsonrpc'),
      body: jsonEncode({
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "service": "common",
          "method": "login",
          "args": [db, username, password]
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _uid = data['result'];
      return _uid != null;
    }
    return false;
  }

  Future<List<dynamic>> fetchFinancialData(String model, List<String> fields, List<dynamic> domain) async {
    if (_uid == null) return [];

    final response = await http.post(
      Uri.parse('$url/jsonrpc'),
      body: jsonEncode({
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "service": "object",
          "method": "execute_kw",
          "args": [
            db, _uid, password,
            model, 
            'search_read',
            [domain],
            {'fields': fields}
          ]
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'] ?? [];
    }
    return [];
  }
}