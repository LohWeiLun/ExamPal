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
    thumbnail: 'assets/icons/schedule.jpg',
  ),
  Category(
    name: 'Fast Note',
    noOfCourses: 'Quickly capture essential exam notes anytime, anywhere.',
    thumbnail: 'assets/icons/fastnote.png',
  ),
  Category(
    name: 'Voice-To-Text',
    noOfCourses: 'Transform spoken thoughts into written notes effortlessly.',
    thumbnail: 'assets/icons/voicetext.jpg',
  ),
  Category(
    name: 'File Conversion',
    noOfCourses: 'Convert various file formats effortlessly.',
    thumbnail: 'assets/icons/conversion.jpg',
  ),
  Category(
    name: 'Image-To-Text',
    noOfCourses: 'Convert images into editable and searchable text effortlessly.',
    thumbnail: 'assets/icons/imageText.jpg',
  ),
  Category(
    name: 'Dictionary',
    noOfCourses: 'Unlock the meaning of any word at your fingertips.',
    thumbnail: 'assets/icons/dictonary.png',
  ),
];
