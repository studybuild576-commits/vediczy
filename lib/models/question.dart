class Question {
  final String id;
  final String textEn;
  final String textHi;
  final List<String> optionsEn;
  final List<String> optionsHi;
  final int correctIndex;
  final String explanation;
  final double negativeMark;

  Question({
    required this.id,
    required this.textEn,
    required this.textHi,
    required this.optionsEn,
    required this.optionsHi,
    required this.correctIndex,
    required this.explanation,
    required this.negativeMark,
  });
}
