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
    noOfCourses: 'Transform spoken thoughts into written notes effortlessly.',
    thumbnail: 'assets/icons/photography.jpg',
  ),
  Category(
    name: 'File Conversion',
    noOfCourses: 'Convert various file formats effortlessly.',
    thumbnail: 'assets/icons/design.jpg',
  ),
  Category(
    name: 'Image-To-Text',
    noOfCourses: 'Convert images into editable and searchable text effortlessly.',
    thumbnail: 'assets/icons/laptop.jpg',
  ),
  Category(
    name: 'Dictonary',
    noOfCourses: 'Unlock the meaning of any word at your fingertips.',
    thumbnail: 'assets/icons/laptop.jpg',
  ),
];
