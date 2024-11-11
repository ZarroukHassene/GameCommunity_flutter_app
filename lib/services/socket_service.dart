import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;

  // Connect to the server
  void connect() {
    socket = IO.io('http://localhost:9090', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();

    socket?.on('receive_message', (data) {
      print('New message received: $data');
    });
  }

  // Send message
  void sendMessage(String sender, String receiver, String message) {
    socket?.emit('send_message', {
      'sender': sender,
      'receiver': receiver,
      'content': message,
    });
  }

  // Disconnect from socket
  void disconnect() {
    socket?.disconnect();
  }
}
