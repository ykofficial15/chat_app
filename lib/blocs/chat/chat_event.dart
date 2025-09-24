abstract class ChatEvent {}

class ConnectChat extends ChatEvent {}

class DisconnectChat extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String to;
  final String content;

  SendMessage(this.to, this.content);
}

class ReceiveMessage extends ChatEvent {
  final Map<String, dynamic> data;
  ReceiveMessage(this.data);
}

class LoadChatHistory extends ChatEvent {
  final String userId;
  LoadChatHistory(this.userId);
}
