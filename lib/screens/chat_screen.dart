import 'package:flutter/material.dart';
import '../services/socket_service.dart';  // Import the SocketService

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController senderController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // List to store messages for UI
  List<Map<String, String>> messages = [];

  // Instance of the SocketService to handle socket connections
  final SocketService _socketService = SocketService();

  // Function to send message and add it to the list
  void _sendMessage() async {
    final sender = senderController.text;
    final receiver = receiverController.text;
    final message = messageController.text;

    if (sender.isNotEmpty && receiver.isNotEmpty && message.isNotEmpty) {
      // Send message to the server via Socket.IO
      _socketService.sendMessage(sender, receiver, message);

      // Update UI with the sent message
      setState(() {
        messages.add({'sender': sender, 'content': message});
      });

      // Clear message input after sending
      messageController.clear();
    } else {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    // Connect to the socket when the screen is loaded
    _socketService.connect();

    // Listen for incoming messages from the server
    _socketService.socket?.on('receive_message', (data) {
      setState(() {
        // Add received message to the list
        messages.add({'sender': data['sender'], 'content': data['content']});
      });
    });
  }

  @override
  void dispose() {
    // Disconnect from the socket when the screen is disposed
    _socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Screen')),
      body: Container(
        color: Colors.black, // Set background color to black
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            // Sender and receiver input fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // Sender TextField
                  TextField(
                    controller: senderController,
                    decoration: InputDecoration(
                      labelText: 'Sender',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[700],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  // Receiver TextField
                  TextField(
                    controller: receiverController,
                    decoration: InputDecoration(
                      labelText: 'Receiver',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[700],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            // Messages ListView (middle part)
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ListTile(
                    title: Text('${message['sender']} :',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(message['content'] ?? '',
                        style: TextStyle(color: Colors.white)),
                    tileColor: Colors.grey[800],
                  );
                },
              ),
            ),

            // Input fields and send button (bottom part)
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.grey[850], // Background color for input area
              child: Row(
                children: [
                  // Message input field
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[700],
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Send button with an icon
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
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
