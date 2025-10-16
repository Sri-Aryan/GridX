import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../providers/game_providers.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppConstants.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppConstants.primaryColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return _buildCell(context, ref, gameState, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, WidgetRef ref, gameState, int index) {
    final isWinningCell = gameState.winningLine?.contains(index) ?? false;
    final cellValue = gameState.board[index];
    final reaction = gameState.recentReactions[index];

    return GestureDetector(
      onTapDown: (_) => HapticFeedback.selectionClick(),
      onTap: () {
        if (cellValue.isEmpty && !gameState.isGameOver) {
          HapticFeedback.mediumImpact();
          ref.read(gameProvider.notifier).makeMove(index);
        }
      },
      child: AnimatedContainer(
        duration: AppConstants.animationDuration,
        decoration: BoxDecoration(
          color: isWinningCell
              ? AppConstants.primaryColor.withOpacity(0.3)
              : AppConstants.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isWinningCell
                ? AppConstants.primaryColor
                : Colors.white.withOpacity(0.1),
            width: isWinningCell ? 3 : 1,
          ),
          boxShadow: isWinningCell
              ? [
            BoxShadow(
              color: AppConstants.primaryColor.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ]
              : [],
        ),
        child: Stack(
          children: [
            Center(
              child: AnimatedScale(
                scale: cellValue.isNotEmpty ? 1.0 : 0.0,
                duration: AppConstants.animationDuration,
                curve: Curves.elasticOut,
                child: Text(
                  cellValue,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: cellValue == 'X'
                        ? AppConstants.xColor
                        : AppConstants.oColor,
                  ),
                ),
              ),
            ),
            if (reaction != null)
              Positioned(
                top: 5,
                right: 5,
                child: AnimatedScale(
                  scale: 1.2,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    reaction,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
