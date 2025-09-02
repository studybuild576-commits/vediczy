class Exam {
  final String id;
  final String name;
  final String type; // SSC or Railway
  final int tier; // 1 or 2
  final List<String> subjects;

  Exam({
    required this.id,
    required this.name,
    required this.type,
    required this.tier,
    required this.subjects,
  });
}
