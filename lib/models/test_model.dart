class Test {
  final String id;
  final String title;
  
  // Naye fields
  final String category; // 'ssc' ya 'railway'
  final String examName; // 'SSC CGL', 'RRB NTPC'
  final int? tier; // 1 ya 2 (null agar tier nahi hai)
  final String testType; // 'mock' ya 'pyq'
  final String testFormat; // 'full' ya 'sectional'
  final String? sectionName; // 'Maths', 'Reasoning' (sirf sectional ke liye)

  // Purane fields
  final int durationInMinutes;
  final int totalMarks;
  final String description;

  Test({
    required this.id,
    required this.title,
    required this.category,
    required this.examName,
    this.tier,
    required this.testType,
    required this.testFormat,
    this.sectionName,
    required this.durationInMinutes,
    required this.totalMarks,
    required this.description,
  });
}
