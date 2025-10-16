import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../modals/game_state.dart';
import '../providers/game_providers.dart';

class VictoryPopup extends ConsumerStatefulWidget {
  final GameState gameState;

  const VictoryPopup({super.key, required this.gameState});

  @override
  ConsumerState<VictoryPopup> createState() => _VictoryPopupState();
}

class _VictoryPopupState extends ConsumerState<VictoryPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();

    _controller = AnimationController(
      duration: AppConstants.winAnimationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final winner = widget.gameState.winner;
    final isDraw = widget.gameState.isDraw;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConstants.cardColor,
                AppConstants.backgroundColor,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDraw
                  ? Colors.orange
                  : (winner == 'X' ? AppConstants.xColor : AppConstants.oColor),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDraw
                    ? Colors.orange
                    : (winner == 'X'
                    ? AppConstants.xColor
                    : AppConstants.oColor))
                    .withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _rotateAnimation,
                child: Text(
                  isDraw ? '🤝' : '🎉',
                  style: const TextStyle(fontSize: 80),
                ),
              ),
              const SizedBox(height: 20),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppConstants.winGradient.createShader(bounds),
                child: Text(
                  isDraw ? 'DRAW!' : 'PLAYER $winner WINS!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    context,
                    'Play Again',
                    AppConstants.primaryColor,
                        () {
                      HapticFeedback.mediumImpact();
                      ref.read(gameProvider.notifier).resetGame();
                      Navigator.pop(context);
                    },
                  ),
                  _buildButton(
                    context,
                    'Home',
                    AppConstants.secondaryColor,
                        () {
                      HapticFeedback.lightImpact();
                      ref.read(gameProvider.notifier).resetAll();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTapDown: (_) => HapticFeedback.selectionClick(),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
