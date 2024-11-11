import 'dart:async';  // Import the timer class
import 'package:flutter/material.dart';
import '/services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  ChatScreen({required this.currentUserId, required this.otherUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List messages = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadMessages();  // Load the initial set of messages
    // Set up a timer to refresh the conversation every 500 milliseconds (0.5 seconds)
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      _loadMessages();
    });
  }

  void _loadMessages() async {
    final fetchedMessages = await ApiService.getMessages(
      widget.currentUserId,
      widget.otherUserId,
    );
    setState(() {
      messages = fetchedMessages;
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await ApiService.sendMessage(
        widget.currentUserId,
        widget.otherUserId,
        _controller.text,
      );
      _controller.clear();
      _loadMessages(); // Reload messages immediately after sending
    }
  }

  @override
  void dispose() {
    _timer.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender'] == widget.currentUserId;
                return ListTile(
                  title: Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      message['message'],
                      style: TextStyle(
                        color: isMe ? Colors.blue : Colors.black,
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
                  child: TextField(controller: _controller),
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
