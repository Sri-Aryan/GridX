import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../modals/game_state.dart';
import '../providers/game_providers.dart';
import '../widgets/emoji.dart';
import '../widgets/victory.dart';
import '../widgets/widget.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    // Show victory popup when game is over
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameState.isGameOver) {
        _showVictoryPopup(context, gameState);
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppConstants.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(gameState),
              _buildScoreBoard(gameState),
              const Spacer(),
              const GameBoard(),
              const Spacer(),
              _buildEmojiReactions(),
              _buildRestartButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameState gameState) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(_headerAnimation),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppConstants.cardColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: gameState.currentPlayer == 'X'
                      ? AppConstants.xColor
                      : AppConstants.oColor,
                  width: 2,
                ),
              ),
              child: Text(
                'Player ${gameState.currentPlayer}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: gameState.currentPlayer == 'X'
                      ? AppConstants.xColor
                      : AppConstants.oColor,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard(GameState gameState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreCard('X', gameState.xScore, AppConstants.xColor),
          Container(
            width: 2,
            height: 50,
            color: Colors.white.withOpacity(0.2),
          ),
          _buildScoreCard('O', gameState.oScore, AppConstants.oColor),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String player, int score, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            'Player $player',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiReactions() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: EmojiReactions(),
    );
  }

  Widget _buildRestartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GestureDetector(
        onTapDown: (_) => HapticFeedback.lightImpact(),
        onTap: () {
          HapticFeedback.mediumImpact();
          ref.read(gameProvider.notifier).resetGame();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppConstants.cardColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppConstants.primaryColor, width: 2),
          ),
          child: const Center(
            child: Text(
              'RESTART',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showVictoryPopup(BuildContext context, GameState gameState) {
    if (!mounted) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => VictoryPopup(gameState: gameState),
        );
      }
    });
  }
}
