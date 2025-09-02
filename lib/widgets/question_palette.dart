import 'package:flutter/material.dart';

class QuestionPalette extends StatelessWidget {
  final int questionCount;
  final int currentIndex;
  final List<bool> answeredStatus;
  final Function(int) onQuestionSelected;

  const QuestionPalette({
    super.key,
    required this.questionCount,
    required this.currentIndex,
    required this.answeredStatus,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(questionCount, (index) {
        Color color;
        if (index == currentIndex) {
          color = Colors.blue;
        } else if (answeredStatus[index]) {
          color = Colors.green;
        } else {
          color = Colors.grey;
        }
        return GestureDetector(
          onTap: () => onQuestionSelected(index),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: color,
            child: Text('${index + 1}',
                style: const TextStyle(color: Colors.white)),
          ),
        );
      }),
    );
  }
}
