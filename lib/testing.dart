import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "game": {
      "id": "jP0kDRJn",
      "pgn": "e4 e5 d4 exd4 Bc4 Nf6 Nf3 Bc5 e5 d5 exf6 dxc4 O-O Qxf6 Re1+ Be6 Ng5 Nc6"
    },
    "puzzle": {
      "solution": [
          "g5e6",
          "f7e6",
          "d1h5",
          "e8d7",
          "h5c5"
      ]
    }
  }
  ''';

  Map<String, dynamic> jsonData = json.decode(jsonString);

  Game game = Game.fromJson(jsonData['game']);
  Puzzle puzzle = Puzzle.fromJson(jsonData['puzzle']);

  print("from testing");
  print('Game PGN: ${game.pgn}');
  print('Puzzle Solution: ${puzzle.solution}');
}

class Game {
  final String pgn;

  Game({required this.pgn});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      pgn: json['pgn'],
    );
  }
}

class Puzzle {
  final List<String> solution;

  Puzzle({required this.solution});

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    return Puzzle(
      solution: List<String>.from(json['solution']),
    );
  }
}
