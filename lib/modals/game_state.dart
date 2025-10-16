import 'package:flutter/foundation.dart';

@immutable
class GameState {
  final List<String> board;
  final String currentPlayer;
  final String? winner;
  final List<int>? winningLine;
  final bool isDraw;
  final int xScore;
  final int oScore;
  final Map<int, String> recentReactions;

  const GameState({
    required this.board,
    required this.currentPlayer,
    this.winner,
    this.winningLine,
    this.isDraw = false,
    this.xScore = 0,
    this.oScore = 0,
    this.recentReactions = const {},
  });

  factory GameState.initial() {
    return GameState(
      board: List.filled(9, ''),
      currentPlayer: 'X',
    );
  }

  GameState copyWith({
    List<String>? board,
    String? currentPlayer,
    String? winner,
    List<int>? winningLine,
    bool? isDraw,
    int? xScore,
    int? oScore,
    Map<int, String>? recentReactions,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      winner: winner ?? this.winner,
      winningLine: winningLine ?? this.winningLine,
      isDraw: isDraw ?? this.isDraw,
      xScore: xScore ?? this.xScore,
      oScore: oScore ?? this.oScore,
      recentReactions: recentReactions ?? this.recentReactions,
    );
  }

  bool get isGameOver => winner != null || isDraw;
}
