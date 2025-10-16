import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constant.dart';

class EmojiReactions extends ConsumerStatefulWidget {
  const EmojiReactions({super.key});

  @override
  ConsumerState<EmojiReactions> createState() => _EmojiReactionsState();
}

class _EmojiReactionsState extends ConsumerState<EmojiReactions> {
  String? _selectedEmoji;
  int? _selectedCell;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Text(
            _selectedEmoji == null
                ? 'Tap emoji, then tap a cell to react'
                : 'Now tap a cell to add $_selectedEmoji',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: AppConstants.emojis.map((emoji) {
              final isSelected = _selectedEmoji == emoji;
              return GestureDetector(
                onTapDown: (_) => HapticFeedback.selectionClick(),
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedEmoji = isSelected ? null : emoji;
                  });
                },
                child: AnimatedContainer(
                  duration: AppConstants.animationDuration,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstants.primaryColor.withOpacity(0.3)
                        : AppConstants.cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.primaryColor
                          : Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
