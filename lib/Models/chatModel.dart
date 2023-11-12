class ChatModel {
  String name;
  String icon;
  bool isGroup;
  String time;
  String currentMessage;
  String status;
  bool select = false;

  ChatModel({
    this.name = "", // Provide a default value
    this.icon = "",
    this.isGroup = true,
    this.time= "",
    this.currentMessage = "",
    this.status = "",
    this.select = false,
  });
}