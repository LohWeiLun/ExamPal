import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void _sendMessage() async {
    String messageContent = _messageController.text;
    String sourceId = widget.sourceId ?? ''; // Get sourceId from widget

    // Update UI with user message
    setState(() {
      messages.add('You: $messageContent');
    });
    _messageController.clear(); // Clear text field after sending message

    // Send message to server asynchronously
    await _fetchBotResponse(messageContent, sourceId);
  }

  Future<void> _fetchBotResponse(String messageContent, String sourceId) async {
    setState(() {
      isLoading = true; // Set loading state to true when sending message
    });

    var response = await http.post(
      Uri.parse('http://192.168.68.104:5000/send_message'),
      // Replace with your server URL
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/chatBack.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  String message = messages[index];
                  bool isUserMessage = message.startsWith('You: ');

                  return ChatBubble(
                    clipper: isUserMessage
                        ? ChatBubbleClipper5(type: BubbleType.sendBubble)
                        : ChatBubbleClipper5(type: BubbleType.receiverBubble),
                    alignment:
                        isUserMessage ? Alignment.topRight : Alignment.topLeft,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    backGroundColor: isUserMessage ? Colors.green : Colors.lightBlue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      // Adjust the padding values here
                      child: Text(isUserMessage ? message.substring(4) : message,
                        style: GoogleFonts.openSans( // Use GoogleFonts to apply Poppins font
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            isLoading
                ? CircularProgressIndicator()
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
                              filled: true, // Enable fill color
                              fillColor: Colors.white,
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
      ),
    );
  }
}
