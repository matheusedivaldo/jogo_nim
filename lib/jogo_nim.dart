class JogoNim {
  int totalPalitos;
  bool ehUsuario;

  JogoNim(this.totalPalitos) : ehUsuario = true;

  void jogar(int palitosRemovidos) {
    totalPalitos -= palitosRemovidos;
  }

  String verificarResultado() {
    if (totalPalitos <= 0) {
      return 'Você venceu!';
    }
    return '';
  }

  void computadorJogar() {
    int computadorRemocao = totalPalitos >= 3 ? 3 : totalPalitos;
    totalPalitos -= computadorRemocao;
  }

  String verificarResultadoComputador() {
    if (totalPalitos <= 0) {
      return 'O computador venceu!';
    }
    return '';
  }
}
