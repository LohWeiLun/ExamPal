class Category {
  String thumbnail;
  String name;
  String noOfCourses;

  Category({
    required this.name,
    required this.noOfCourses,
    required this.thumbnail,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Schedule',
    noOfCourses: 'Empowers users to meticulously plan their study sessions.',
    thumbnail: 'assets/icons/laptop.jpg',
  ),
  Category(
    name: 'Fast Note',
    noOfCourses: 'Quickly capture essential exam notes anytime, anywhere.',
    thumbnail: 'assets/icons/accounting.jpg',
  ),
  Category(
    name: 'Voice-To-Text',
    noOfCourses: 'Transform spoken thoughts into written notes effortlessly',
    thumbnail: 'assets/icons/photography.jpg',
  ),
  Category(
    name: 'File Conversion',
    noOfCourses: 'Convert various file formats effortlessly with our File Conversion tool',
    thumbnail: 'assets/icons/design.jpg',
  ),
];
