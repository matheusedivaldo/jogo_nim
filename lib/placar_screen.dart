import 'package:flutter/material.dart';
import 'api_service.dart';

class PlacarScreen extends StatefulWidget {
  @override
  _PlacarScreenState createState() => _PlacarScreenState();
}

class _PlacarScreenState extends State<PlacarScreen> {
  late Future<List<dynamic>> scores;

  @override
  void initState() {
    super.initState();
    scores = ApiService().getScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placar'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: scores,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final scores = snapshot.data!;
                return ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    final score = scores[index];
                    return ListTile(
                      title: Text(score['nome'],
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text('Placar: ${score['placar']}',
                          style: TextStyle(color: Colors.white70)),
                    );
                  },
                );
              } else {
                return Center(child: Text('Nenhum placar encontrado.'));
              }
            },
          ),
        ],
      ),
    );
  }
}