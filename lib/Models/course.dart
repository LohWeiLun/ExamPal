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
    name: "Fast Note",
    thumbnail: "assets/icons/react.jpg",
  ),
  Course(
    name: "Voice-To-Text",
    thumbnail: "assets/icons/node.png",
  ),
  Course(
    name: "File Conversion",
    thumbnail: "assets/icons/flutter.jpg",
  ),
  Course(
    name: "Community",
    thumbnail: "assets/icons/react.jpg",
  ),
  Course(
    name: "Timer",
    thumbnail: "assets/icons/node.png",
  ),
];