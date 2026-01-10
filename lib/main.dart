import 'package:flutter/material.dart';

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
  List<String> displayElement = List.filled(9, '');
  List<int> oMoves = [];
  List<int> xMoves = [];
  bool oTurn = true;
  int oScore = 0;
  int xScore = 0;

  // COLORS
  final Color bgTop = const Color(0xFF1a1a2e);
  final Color bgBottom = const Color(0xFF16213e);
  final Color oColor = const Color(0xFF00fff5); // Cyan
  final Color xColor = const Color(0xFFff2e63); // Pinkish Red

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
              // 1. TOP HEADER
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
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: _showInfoDialog,
                    ),
                  ],
                ),
              ),

              // 2. SCOREBOARD
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScore("PLAYER O", oScore, oColor, oTurn),
                  const SizedBox(width: 40),
                  _buildScore("PLAYER X", xScore, xColor, !oTurn),
                ],
              ),
              
              const Spacer(),

              // 3. THE GAME GRID
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
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
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
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

              const Spacer(),

              // 4. FOOTER
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

  // --- WIDGETS ---
  
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

  // --- LOGIC ---

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bgBottom,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("About", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.code, color: Colors.cyanAccent, size: 50),
            SizedBox(height: 20),
            Text("Created by", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 5),
            Text(
              "techiemonk", 
              style: TextStyle(
                color: Colors.white, 
                fontSize: 22, 
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2
              )
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Close", style: TextStyle(color: Colors.cyanAccent)),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  void _tapped(int index) {
    if (displayElement[index] == '') {
      setState(() {
        if (oTurn) {
          if (oMoves.length >= 3) {
            int oldest = oMoves.removeAt(0);
            displayElement[oldest] = '';
          }
          oMoves.add(index);
          displayElement[index] = 'O';
        } else {
          if (xMoves.length >= 3) {
            int oldest = xMoves.removeAt(0);
            displayElement[oldest] = '';
          }
          xMoves.add(index);
          displayElement[index] = 'X';
        }
        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    List<List<int>> checks = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var check in checks) {
      String p1 = displayElement[check[0]];
      String p2 = displayElement[check[1]];
      String p3 = displayElement[check[2]];
      if (p1 != '' && p1 == p2 && p2 == p3) {
        _showWinDialog(p1);
        return;
      }
    }
  }

  void _showWinDialog(String winner) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bgBottom,
        title: const Text("Winner!", style: TextStyle(color: Colors.white)),
        content: Text("Player $winner takes the round.", style: const TextStyle(color: Colors.white70)),
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
    });
  }
}