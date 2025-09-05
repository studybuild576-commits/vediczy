class Question {
  final String id;
  final String testId;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String solutionText;
  final String subject;

  Question({
    required this.id,
    required this.testId,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.solutionText,
    required this.subject,
  });
}
