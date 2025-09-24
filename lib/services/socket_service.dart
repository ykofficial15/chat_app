import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../utils/storage.dart';

class SocketService {
  late IO.Socket socket;

  void connect() {
    final token = AppStorage.getToken();
    socket = IO.io(
      "http://localhost:5002",
      IO.OptionBuilder().setTransports(['websocket']).enableForceNew().setAuth({
        'token': token,
      }).build(),
    );

    socket.onConnect((_) => print("Socket connected"));
    socket.onDisconnect((_) => print("Socket disconnected"));
  }

  void sendPrivateMessage(String to, String content) {
    socket.emit("private-message", {"to": to, "content": content});
  }

  void onPrivateMessage(Function(Map data) callback) {
    socket.on("private-message", (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
