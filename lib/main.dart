import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TicTacToeGame(),
  ));
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  final AudioPlayer player = AudioPlayer();
  
  // --- SETTINGS ---
  bool isSoundOn = true;
  bool isSinglePlayer = false; 
  bool isComputerThinking = false;

  List<String> displayElement = List.filled(9, '');
  List<int> oMoves = [];
  List<int> xMoves = [];
  bool oTurn = true; 
  int oScore = 0;
  int xScore = 0;

  // COLORS
  final Color bgTop = const Color(0xFF1a1a2e);
  final Color bgBottom = const Color(0xFF16213e);
  final Color oColor = const Color(0xFF00fff5);
  final Color xColor = const Color(0xFFff2e63);

  final List<Color> tileColors = const [
    Color(0xFFEF5350), Color(0xFFFFA726), Color(0xFFFFEE58),
    Color(0xFF66BB6A), Color(0xFF29B6F6), Color(0xFFAB47BC),
    Color(0xFFEC407A), Color(0xFF7E57C2), Color(0xFF26A69A),
  ];

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    if (isSoundOn) {
      try {
        await player.stop();
        await player.play(AssetSource('pop.mp3'));
      } catch (e) {
        debugPrint("Error playing sound: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TIC TAC TOE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: _showSettingsDialog,
                    ),
                  ],
                ),
              ),

              // SCOREBOARD
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScore(isSinglePlayer ? "YOU (O)" : "PLAYER O", oScore, oColor, oTurn),
                  const SizedBox(width: 40),
                  _buildScore(isSinglePlayer ? "AI (X)" : "PLAYER X", xScore, xColor, !oTurn),
                ],
              ),
              
              const Spacer(),

              // GAME GRID
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: AbsorbPointer(
                  absorbing: isComputerThinking,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _tapped(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: tileColors[index].withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: tileColors[index].withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Text(
                                displayElement[index],
                                key: ValueKey(displayElement[index]),
                                style: TextStyle(
                                  color: displayElement[index] == 'O' ? oColor : xColor,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    BoxShadow(
                                      color: displayElement[index] == 'O' ? oColor : xColor,
                                      blurRadius: 20,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const Spacer(),

              // FOOTER
              const Text(
                "Infinite Mode: Max 3 moves each",
                style: TextStyle(color: Colors.white38, letterSpacing: 1),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _clearBoard,
                child: const Text("RESET GAME"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScore(String label, int score, Color color, bool isTurn) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isTurn ? color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isTurn ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(score.toString(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: bgBottom,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Settings", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Created by @techiemonk", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  
                  SwitchListTile(
                    title: const Text("Sound Effects", style: TextStyle(color: Colors.white)),
                    value: isSoundOn,
                    activeColor: oColor,
                    onChanged: (bool value) {
                      setStateDialog(() => isSoundOn = value);
                      setState(() {});
                    },
                  ),

                  SwitchListTile(
                    title: const Text("Single Player", style: TextStyle(color: Colors.white)),
                    subtitle: const Text("vs Computer (Medium)", style: TextStyle(color: Colors.white38, fontSize: 12)),
                    value: isSinglePlayer,
                    activeColor: xColor,
                    onChanged: (bool value) {
                      setStateDialog(() => isSinglePlayer = value);
                      setState(() {
                        _clearBoard();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Close", style: TextStyle(color: Colors.cyanAccent)),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            );
          },
        );
      },
    );
  }

  // --- GAME LOGIC ---

  void _tapped(int index) {
    if (displayElement[index] == '') {
      _playSound();

      setState(() {
        if (oTurn) {
          // Human
          _handleMove(oMoves, index, 'O');
        } else {
          // AI or Human 2
          _handleMove(xMoves, index, 'X');
        }

        bool hasWon = _checkWinner();
        
        if (!hasWon) {
          oTurn = !oTurn;
          
          if (isSinglePlayer && !oTurn) {
            _playComputerTurn();
          }
        }
      });
    }
  }

  void _handleMove(List<int> movesList, int index, String symbol) {
    if (movesList.length >= 3) {
      int oldest = movesList.removeAt(0);
      displayElement[oldest] = '';
    }
    movesList.add(index);
    displayElement[index] = symbol;
  }

  // --- IMPROVED AI LOGIC ---
  void _playComputerTurn() async {
    setState(() => isComputerThinking = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted || displayElement.every((e) => e == '')) {
      setState(() => isComputerThinking = false);
      return;
    }

    int bestMove = _getBestAiMove();
    _tapped(bestMove);

    setState(() => isComputerThinking = false);
  }

  int _getBestAiMove() {
    // 1. TRY TO WIN (Priority 1)
    int? winMove = _findSpotToWinOrBlock('X');
    if (winMove != null) return winMove;

    // 2. BLOCK PLAYER (Priority 2)
    int? blockMove = _findSpotToWinOrBlock('O');
    if (blockMove != null) return blockMove;

    // 3. PLAY RANDOM
    List<int> available = [];
    for (int i = 0; i < 9; i++) {
      if (displayElement[i] == '') available.add(i);
    }
    if (available.isNotEmpty) {
      return available[Random().nextInt(available.length)];
    }
    return 0;
  }

  // New, Simpler Logic for finding winning/blocking spots
  int? _findSpotToWinOrBlock(String player) {
    // All possible winning lines
    List<List<int>> lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Cols
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];

    for (var line in lines) {
      var a = displayElement[line[0]];
      var b = displayElement[line[1]];
      var c = displayElement[line[2]];

      // Check if the line has 2 of the specific player and 1 empty spot
      if (a == player && b == player && c == '') return line[2];
      if (a == player && c == player && b == '') return line[1];
      if (b == player && c == player && a == '') return line[0];
    }
    return null;
  }

  bool _checkWinner() {
    List<List<int>> lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var line in lines) {
      String p1 = displayElement[line[0]];
      String p2 = displayElement[line[1]];
      String p3 = displayElement[line[2]];
      if (p1 != '' && p1 == p2 && p2 == p3) {
        _showWinDialog(p1);
        return true;
      }
    }
    return false;
  }

  void _showWinDialog(String winner) {
    String message = isSinglePlayer 
        ? (winner == 'O' ? "You Won!" : "AI Won!") 
        : "Player $winner takes the round.";

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bgBottom,
        title: const Text("Game Over", style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("Play Again", style: TextStyle(color: Colors.white)),
            onPressed: () {
              _clearBoard();
              if (winner == 'O') oScore++; else xScore++;
              setState(() {});
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _clearBoard() {
    setState(() {
      displayElement = List.filled(9, '');
      oMoves.clear();
      xMoves.clear();
      oTurn = true; 
      isComputerThinking = false;
    });
  }
}