class ChatsModel {
  final String msg;
  final int chatIndex;

  ChatsModel({required this.msg, required this.chatIndex});

  factory ChatsModel.fromJson(Map<String, dynamic> json) => ChatsModel(
    msg: json["msg"],
    chatIndex: json["chatIndex"],
  );
}