class Category {
  String thumbnail;
  String name;
  int noOfCourses;
  double bottomPadding; // Add a new property for padding

  Category({
    required this.name,
    required this.noOfCourses,
    required this.thumbnail,
    this.bottomPadding = 5.8, // Default padding value
  });
}

List<Category> categoryList = [
  Category(
    name: 'Schedule',
    noOfCourses: 55,
    thumbnail: 'assets/icons/accounting.png',
  ),
  Category(
    name: 'Fast Notes',
    noOfCourses: 20,
    thumbnail: 'assets/icons/accounting.png',
  ),
  Category(
    name: 'File Conversion',
    noOfCourses: 16,
    thumbnail: 'assets/icons/photography.png',
  ),
  Category(
    name: 'Voice-To-Text',
    noOfCourses: 25,
    thumbnail: 'assets/icons/design.png',
  ),
];
