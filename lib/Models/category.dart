class Category {
  String thumbnail;
  String name;
  int noOfCourses;

  Category({
    required this.name,
    required this.noOfCourses,
    required this.thumbnail,
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