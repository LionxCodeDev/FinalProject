
class IaTresencallle {

  final List<List<int>> _combinacionesGanadoras = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
  ];

  List<int>? verificarGanador(List<String> tablero){

    for (var combo in _combinacionesGanadoras) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (tablero[a] != "" && tablero[a] == tablero[b] && tablero[a] == tablero[c]) {
        return combo;
      }
    }

    return null; 
  }
  
  int calcularMovimiento(List<String> tablero){

    // Intenta Ganar leyendo patrones
    for (var combo in _combinacionesGanadoras) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (_ganar(tablero, a, b, c, "O")) return _espacio(tablero, a, b, c);
    }

    // Intenta Bloquear leyendo patrones
    for (var combo in _combinacionesGanadoras) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (_ganar(tablero, a, b, c, "X")) return _espacio(tablero, a, b, c);
    }

    // Elige una posicion random para jugar
    final vacios = <int>[];
    for (int i = 0; i < tablero.length; i++) {
      if (tablero[i] == "") vacios.add(i);
    }

    if (vacios.isNotEmpty) {
      vacios.shuffle();
      return vacios.first;
    }

    return -1; 
  }

  bool _ganar(List<String> tablero, int a, int b, int c, String marca) {
    final line = [tablero[a], tablero[b], tablero[c]];
    return line.where((v) => v == marca).length == 2 &&
           line.contains("");
  }
  
  int _espacio(List<String> tablero, int a, int b, int c) {
    if (tablero[a] == "") return a;
    if (tablero[b] == "") return b;
    return c;
  }

}