import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final int? selectedOption;
  final Function(int) onOptionSelected;
  final bool isHindi;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.onOptionSelected,
    this.isHindi = false,
  });

  @override
  Widget build(BuildContext context) {
    final questionText = isHindi ? question.textHi : question.textEn;
    final options = isHindi ? question.optionsHi : question.optionsEn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        ...List.generate(options.length, (index) {
          return RadioListTile<int>(
            title: Text(options[index]),
            value: index,
            groupValue: selectedOption,
            onChanged: (value) {
              if (value != null) {
                onOptionSelected(value);
              }
            },
          );
        }),
      ],
    );
  }
}
