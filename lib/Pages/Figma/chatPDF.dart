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
  bool isLoading = false; // Track loading state

  void _sendMessage() {
    String messageContent = _messageController.text;
    String sourceId = widget.sourceId ?? ''; // Get sourceId from widget

    // Update UI with user message
    setState(() {
      messages.add('You: $messageContent');
    });
    _messageController.clear(); // Clear text field after sending message

    // Send message to server asynchronously
    _fetchBotResponse(messageContent, sourceId);
  }

  Future<void> _fetchBotResponse(String messageContent, String sourceId) async {
    setState(() {
      isLoading = true; // Set loading state to true when sending message
    });

    var response = await http.post(
      Uri.parse('http://192.168.68.103:5000/send_message'), // Replace with your server URL
      body: {
        'source_id': sourceId,
        'message_content': messageContent,
      },
    );

    setState(() {
      isLoading = false; // Set loading state to false when response is received
    });

    if (response.statusCode == 200) {
      // Message sent successfully, update UI with bot response
      String botResponse = response.body;
      final decodedResponse = json.decode(botResponse);
      String formattedResponse = decodedResponse['Result'];

      setState(() {
        messages.add(formattedResponse);
      });
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
                        isUserMessage ? message.substring(4) : message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          isLoading
              ? CircularProgressIndicator() // Show loading indicator when isLoading is true
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
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