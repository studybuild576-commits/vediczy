import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final Duration timeRemaining;
  final Function onSubmit;
  final int answeredCount;
  final int totalQuestions;
  final bool isMarkForReview;
  final Function(bool) onMarkForReviewToggle;

  const TopBar({
    super.key,
    required this.timeRemaining,
    required this.onSubmit,
    required this.answeredCount,
    required this.totalQuestions,
    required this.isMarkForReview,
    required this.onMarkForReviewToggle,
  });

  String _formatDuration() {
    final minutes = timeRemaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text('Time Left: ${_formatDuration()}', style: const TextStyle(fontSize: 16)),
         Text('Answered: $answeredCount / $totalQuestions', style: const TextStyle(fontSize: 16)),
         Row(
           children: [
             const Text('Mark for Review'),
             Switch(
               value: isMarkForReview,
               onChanged: (value) => onMarkForReviewToggle(value),
             ),
           ],
         ),
         ElevatedButton(
           onPressed: () => onSubmit(),
           child: const Text('Submit'),
         )
      ],
    );
  }
}
