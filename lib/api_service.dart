import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://matheusedivaldo.pythonanywhere.com/score";

  Future<List<dynamic>> getScores() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao obter scores');
    }
  }

  Future<void> addScore(String nome, int placar) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'placar': placar}),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar score');
    }
  }
}