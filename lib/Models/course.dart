class Course {
  String name;
  String thumbnail;

  Course({
    required this.name,
    required this.thumbnail,
  });
}

List<Course> courses = [
  Course(
    name: "Schedule",
    thumbnail: "assets/icons/flutter.jpg",
  ),
  Course(
    name: "Notes Summarization",
    thumbnail: "assets/icons/react.jpg",
  ),
  Course(
    name: "Voice To Text",
    thumbnail: "assets/icons/node.png",
  ),
  Course(
    name: "File Conversion",
    thumbnail: "assets/icons/node.png",
  ),
  Course(
    name: "Image-To-Text Recognition",
    thumbnail: "assets/icons/flutter.jpg",
  ),
  Course(
    name: "Community",
    thumbnail: "assets/icons/react.jpg",
  ),
  Course(
    name: "Profile",
    thumbnail: "assets/icons/node.png",
  ),
];