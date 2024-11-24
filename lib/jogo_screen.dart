import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'jogo_nim.dart';

class JogoScreen extends StatefulWidget {
  @override
  _JogoScreenState createState() => _JogoScreenState();
}

class _JogoScreenState extends State<JogoScreen> {
  late JogoNim jogoNim;
  String resultado = '';
  int usuarioVitorias = 0;
  int computadorVitorias = 0;

  @override
  void initState() {
    super.initState();
    carregarPlacar();
    iniciarJogo(10);
  }

  void carregarPlacar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioVitorias = prefs.getInt('usuarioVitorias') ?? 0;
      computadorVitorias = prefs.getInt('computadorVitorias') ?? 0;
    });
  }

  void salvarPlacar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usuarioVitorias', usuarioVitorias);
    await prefs.setInt('computadorVitorias', computadorVitorias);
  }

  void iniciarJogo(int palitos) {
    setState(() {
      jogoNim = JogoNim(palitos);
      resultado = '';
    });
  }

  void jogar(int palitosRemovidos) {
    if (palitosRemovidos > jogoNim.totalPalitos) {
      exibirMensagemErro(
          'Você não pode remover mais palitos do que o disponível!');
      return;
    }

    setState(() {
      jogoNim.jogar(palitosRemovidos);
      resultado = jogoNim.verificarResultado();

      if (resultado.isNotEmpty) {
        if (resultado == 'Você venceu!') {
          usuarioVitorias++;
          salvarPlacar();
        }
      } else {
        jogoNim.computadorJogar();
        resultado = jogoNim.verificarResultadoComputador();

        if (resultado == 'O computador venceu!') {
          computadorVitorias++;
          salvarPlacar();
        }
      }
    });
  }

  void exibirMensagemErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Nim'),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Palitos restantes: ${jogoNim.totalPalitos}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                if (resultado.isNotEmpty)
                  Text(
                    resultado,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow),
                  ),
                if (jogoNim.totalPalitos > 0)
                  Wrap(
                    spacing: 10,
                    children: [1, 2, 3].map((palitos) {
                      return ElevatedButton(
                        onPressed: () => jogar(palitos),
                        child: Text('Remover $palitos'),
                      );
                    }).toList(),
                  ),
                ElevatedButton(
                  onPressed: () {
                    iniciarJogo(10);
                  },
                  child: Text('Reiniciar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
