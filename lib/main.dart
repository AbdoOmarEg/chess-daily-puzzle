import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chess Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> solution = [];
  var ignore_first = true;
  var idx = 0;
  var success = false;
  ChessBoardController controller = ChessBoardController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      // if (idx % 2 == 1) {
      //   final lastMove = solution.last ?? "error";
      //   final lastMoveFrom = lastMove.substring(0, 2);
      //   final lastMoveTo = lastMove.substring(2);
      //   print("yarab yt7rak");
      //   controller.makeMove(from: lastMoveFrom, to: lastMoveTo);
      //   idx++;
      // }
      if (solution.isNotEmpty && idx == solution.length - 1) {
        // setState to make Success appear
        print("succ");
        success = true;
        return;
      }
      var is_it_true = checkSolution();
      if (!ignore_first) {
        print("is_it_true $is_it_true");
        if (!is_it_true) {
          controller.game.undo();
        } else {
          if (idx % 2 == 1) {
            print("hello darkness my new friend");
            final lastMove = solution[idx];
            print("$lastMove");
            final lastMoveFrom = lastMove.substring(0, 2);
            print("$lastMoveFrom");
            final lastMoveTo = lastMove.substring(2);
            print("$lastMoveTo");
            print("yarab yt7rak");
            print("yarab yt7rak");
            setState(() {
              controller.makeMove(from: lastMoveFrom, to: lastMoveTo);
            });
          }
          // idx++;
        }
      }
      ignore_first = false;
    });
    loadGame();
    // controller.addListener(_onMoveMade);
  }

  // void _onMoveMade() {
  //   checkSolution();
  // }

  void loadGame() {
    // checkSolution();
    loadNewGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ChessBoard(
                controller: controller,
                boardColor: BoardColor.orange,
                // arrows: [
                //   BoardArrow(
                //     from: 'd2',
                //     to: 'd4',
                //     color: Colors.red.withOpacity(0.5),
                //   ),
                // ],
                boardOrientation: PlayerColor.white,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Chess>(
              valueListenable: controller,
              builder: (context, game, _) {
                return Text(
                  controller.getSan().fold(
                        '',
                        (previousValue, element) =>
                            previousValue + '\n' + (element ?? ''),
                      ),
                );
              },
            ),
          ),
          if (idx != 0 &&
              idx ==
                  solution.length -
                      1) // Check if idx equals the length of the solution list
            Text(
              "Magnum Carlos!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  bool checkSolution() {
    var move = controller.getSan();
    print("the move $move");
    var betterMoves = controller.better_san_moves();
    print("the better move $betterMoves");

    String extractedMove = betterMoves.last ?? "error";
    // for (var move in betterMoves) {
    //   move = move!.replaceAll(' ', '').replaceAll(',', '');
    //   if (move.length >= 4) {
    //     extractedMove = move.substring(move.length - 4);
    //     break;
    //   }
    // }

    print("extracted move notation: $extractedMove");
    print("solution list: $solution");
    print("idx : $idx");
    if (solution.isNotEmpty &&
        idx < solution.length &&
        extractedMove == solution[idx]) {
      idx++;
      return true;
    } else {
      // if the move is not correct, don't undo it, or don't do it at all
      return false;
    }
  }

  void loadNewGame() async {
    final response =
        await http.get(Uri.parse("https://lichess.org/api/puzzle/daily"));
    final jsonData = response.body;
    print(jsonData);
    Map<String, dynamic> jsonDataParsed = json.decode(jsonData);

    Game game = Game.fromJson(jsonDataParsed['game']);
    Puzzle puzzle = Puzzle.fromJson(jsonDataParsed['puzzle']);

    controller.loadPGN(game.pgn);

    solution = puzzle.solution;
    solution.add("fill");
    print("the solution $solution");
  }
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

// parse all json fields
// class Game {
//   final String id;
//   final Perf perf;
//   final bool rated;
//   final List<Player> players;
//   final String pgn;
//   final String clock;

//   Game({
//     required this.id,
//     required this.perf,
//     required this.rated,
//     required this.players,
//     required this.pgn,
//     required this.clock,
//   });

//   factory Game.fromJson(Map<String, dynamic> json) {
//     return Game(
//       id: json['id'],
//       perf: Perf.fromJson(json['perf']),
//       rated: json['rated'],
//       players: List<Player>.from(
//           json['players'].map((player) => Player.fromJson(player))),
//       pgn: json['pgn'],
//       clock: json['clock'],
//     );
//   }
// }

// class Perf {
//   final String key;
//   final String name;

//   Perf({
//     required this.key,
//     required this.name,
//   });

//   factory Perf.fromJson(Map<String, dynamic> json) {
//     return Perf(
//       key: json['key'],
//       name: json['name'],
//     );
//   }
// }

// class Player {
//   final String name;
//   final String color;
//   final int rating;

//   Player({
//     required this.name,
//     required this.color,
//     required this.rating,
//   });

//   factory Player.fromJson(Map<String, dynamic> json) {
//     return Player(
//       name: json['name'],
//       color: json['color'],
//       rating: json['rating'],
//     );
//   }
// }

// class Puzzle {
//   final String id;
//   final int rating;
//   final int plays;
//   final List<String> solution;
//   final List<String> themes;
//   final int initialPly;

//   Puzzle({
//     required this.id,
//     required this.rating,
//     required this.plays,
//     required this.solution,
//     required this.themes,
//     required this.initialPly,
//   });

//   factory Puzzle.fromJson(Map<String, dynamic> json) {
//     return Puzzle(
//       id: json['id'],
//       rating: json['rating'],
//       plays: json['plays'],
//       solution: List<String>.from(json['solution']),
//       themes: List<String>.from(json['themes']),
//       initialPly: json['initialPly'],
//     );
//   }
// }
