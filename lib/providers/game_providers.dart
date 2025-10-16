import 'package:flutter_riverpod/legacy.dart';
import '../modals/game_state.dart';

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState.initial());

  void makeMove(int index) {
    if (state.board[index].isNotEmpty || state.isGameOver) return;

    final newBoard = List<String>.from(state.board);
    newBoard[index] = state.currentPlayer;

    final winner = _checkWinner(newBoard);
    final winningLine = winner != null ? _getWinningLine(newBoard, winner) : null;
    final isDraw = !newBoard.contains('') && winner == null;

    int newXScore = state.xScore;
    int newOScore = state.oScore;

    if (winner == 'X') {
      newXScore++;
    } else if (winner == 'O') {
      newOScore++;
    }

    state = state.copyWith(
      board: newBoard,
      currentPlayer: state.currentPlayer == 'X' ? 'O' : 'X',
      winner: winner,
      winningLine: winningLine,
      isDraw: isDraw,
      xScore: newXScore,
      oScore: newOScore,
    );
  }

  void addReaction(int cellIndex, String emoji) {
    final newReactions = Map<int, String>.from(state.recentReactions);
    newReactions[cellIndex] = emoji;
    state = state.copyWith(recentReactions: newReactions);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final currentReactions = Map<int, String>.from(state.recentReactions);
        currentReactions.remove(cellIndex);
        state = state.copyWith(recentReactions: currentReactions);
      }
    });
  }

  String? _checkWinner(List<String> board) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]].isNotEmpty &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        return board[pattern[0]];
      }
    }
    return null;
  }

  List<int>? _getWinningLine(List<String> board, String winner) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == winner &&
          board[pattern[1]] == winner &&
          board[pattern[2]] == winner) {
        return pattern;
      }
    }
    return null;
  }

  void resetGame() {
    state = GameState.initial().copyWith(
      xScore: state.xScore,
      oScore: state.oScore,
    );
  }

  void resetAll() {
    state = GameState.initial();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
