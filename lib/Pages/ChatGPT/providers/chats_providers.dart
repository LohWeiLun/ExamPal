import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../services/api_services.dart';

class ChatProvider with ChangeNotifier {
  List<ChatsModel> chatList = [];
  List<ChatsModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatsModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll((await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      )) as Iterable<ChatsModel>);
    } else {
      chatList.addAll((await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      )) as Iterable<ChatsModel>);
    }
    notifyListeners();
  }
}