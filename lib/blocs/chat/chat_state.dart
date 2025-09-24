import '../../models/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatConnected extends ChatState {
  final List<MessageModel> messages;
  ChatConnected(this.messages);
}
