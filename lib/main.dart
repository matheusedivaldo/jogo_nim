import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'jogo_nim.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo Nim',
      home: JogoNimScreen(),
    );
  }
}

class JogoNimScreen extends StatefulWidget {
  @override
  _JogoNimScreenState createState() => _JogoNimScreenState();
}

class _JogoNimScreenState extends State<JogoNimScreen> {
  late JogoNim jogoNim;
  String resultado = '';
  int usuarioVitorias = 0;
  int computadorVitorias = 0;

  @override
  void initState() {
    super.initState();
    _carregarPlacar();
    iniciarJogo(10);
  }

  void _carregarPlacar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioVitorias = prefs.getInt('usuarioVitorias') ?? 0;
      computadorVitorias = prefs.getInt('computadorVitorias') ?? 0;
    });
  }

  void _salvarPlacar() async {
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
      _exibirMensagemErro(
          'Você não pode remover mais palitos do que o disponível!');
      return;
    }

    setState(() {
      jogoNim.jogar(palitosRemovidos);
      resultado = jogoNim.verificarResultado();

      if (resultado.isNotEmpty) {
        if (resultado == 'Você venceu!') {
          usuarioVitorias++;
          _salvarPlacar();
        }
      } else {
        jogoNim.computadorJogar();
        resultado = jogoNim.verificarResultadoComputador();

        if (resultado == 'O computador venceu!') {
          computadorVitorias++;
          _salvarPlacar();
        }
      }
    });
  }

  void _exibirMensagemErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;
    final alturaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 68, 196, 255),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'JOGO NIM',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(127, 0, 178, 1),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FractionallySizedBox(
                widthFactor: larguraTela < 600 ? 0.95 : 0.7,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Vitórias do Usuário: $usuarioVitorias',
                            style: TextStyle(
                              fontSize: larguraTela < 400 ? 16 : 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 155, 89, 182),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Vitórias do Computador: $computadorVitorias',
                            style: TextStyle(
                              fontSize: larguraTela < 400 ? 16 : 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 155, 89, 182),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: larguraTela * 0.8,
                        height: alturaTela * 0.3,
                        child: Image.network(
                          'https://cdni.iconscout.com/illustration/premium/thumb/playing-game-in-smartphone-illustration-download-svg-png-gif-file-formats--gaming-app-mobile-digital-video-pack-sports-games-illustrations-5663147.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Palitos restantes: ${jogoNim.totalPalitos}',
                        style: TextStyle(fontSize: larguraTela < 400 ? 20 : 24),
                      ),
                      const SizedBox(height: 20),
                      if (resultado.isNotEmpty)
                        Text(
                          resultado,
                          style: TextStyle(
                            fontSize: larguraTela < 400 ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (jogoNim.totalPalitos == 0)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(255, 193, 7, 1),
                          ),
                          onPressed: () {
                            iniciarJogo(10);
                          },
                          child: const Text('Reiniciar Jogo'),
                        ),
                      if (jogoNim.ehUsuario && jogoNim.totalPalitos > 0)
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            _botaoJogada(1, larguraTela),
                            _botaoJogada(2, larguraTela),
                            _botaoJogada(3, larguraTela),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botaoJogada(int palitos, double larguraTela) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(255, 193, 7, 1),
        padding: EdgeInsets.symmetric(
          horizontal: larguraTela < 400 ? 8 : 16,
          vertical: larguraTela < 400 ? 12 : 16,
        ),
      ),
      onPressed: () => jogar(palitos),
      child: Text(
        'Remover $palitos',
        style: TextStyle(fontSize: larguraTela < 400 ? 14 : 16),
      ),
    );
  }
}
