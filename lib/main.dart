import 'package:flutter/material.dart';
import 'jogo_nim.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo Nim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JogoNimScreen(),
    );
  }
}

class JogoNimScreen extends StatefulWidget {
  @override
  _JogoNimScreenState createState() => _JogoNimScreenState();
}

class _JogoNimScreenState extends State<JogoNimScreen> {
  int totalPalitos = 0;
  bool ehUsuario = true;
  String resultado = '';

  void iniciarJogo(int palitos) {
    setState(() {
      totalPalitos = palitos;
      ehUsuario = true;
      resultado = '';
    });
  }

  void jogar(int palitosRemovidos) {
    setState(() {
      totalPalitos -= palitosRemovidos;
      if (totalPalitos <= 0) {
        resultado = 'Você venceu!';
      } else {
        ehUsuario = false;
        int computadorRemocao = (palitosRemovidos == 1) ? 2 : 1;
        if (totalPalitos >= 3) {
          computadorRemocao = 3;
        } else {
          computadorRemocao = totalPalitos;
        }
        totalPalitos -= computadorRemocao;
        if (totalPalitos <= 0) {
          resultado = 'O computador venceu!';
        } else {
          ehUsuario = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Nim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Palitos restantes: $totalPalitos',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            if (resultado.isNotEmpty)
              Text(
                resultado,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            if (totalPalitos == 0)
              ElevatedButton(
                onPressed: () {
                  iniciarJogo(10);
                },
                child: Text('Reiniciar Jogo'),
              ),
            if (ehUsuario && totalPalitos > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => jogar(1),
                    child: Text('Remover 1'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => jogar(2),
                    child: Text('Remover 2'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => jogar(3),
                    child: Text('Remover 3'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}