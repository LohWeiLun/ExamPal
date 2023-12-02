import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPDFPage extends StatefulWidget {
  final String? sourceId;

  const ChatPDFPage({Key? key, this.sourceId}) : super(key: key);

  @override
  _ChatPDFPageState createState() => _ChatPDFPageState();
}

class _ChatPDFPageState extends State<ChatPDFPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> messages = []; // Store chat messages here

  void _sendMessage() async {
    String messageContent = _messageController.text;
    String sourceId = widget.sourceId ?? ''; // Get sourceId from widget

    // Send message to server
    var response = await http.post(
      Uri.parse('http://192.168.68.104:5000/send_message'), // Replace with your server URL
      body: {
        'source_id': sourceId,
        'message_content': messageContent,
      },
    );

    if (response.statusCode == 200) {
      // Message sent successfully, update UI
      String botResponse = response.body;
      final decodedResponse = json.decode(botResponse);
      String formattedResponse = decodedResponse['Result'];

      setState(() {
        messages.add('You: $messageContent'); // Adjusted line
        messages.add(formattedResponse);
      });
      _messageController.clear(); // Clear text field after sending message
    } else {
      // Handle error if message fails to send
      // You can show an error message or perform appropriate actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat PDF'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                String message = messages[index];
                bool isUserMessage = message.startsWith('You: ');

                return ListTile(
                  title: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.blue : Colors.green,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        isUserMessage ? message.substring(4) : message, // Adjusted line
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0), // Adjust the radius to your preference
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
