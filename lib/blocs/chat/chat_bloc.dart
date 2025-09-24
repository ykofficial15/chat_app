import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/message.dart';
import '../../services/socket_service.dart';
import '../../services/chat_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketService socketService;
  List<MessageModel> messages = [];

  ChatBloc(this.socketService) : super(ChatInitial()) {
    on<ConnectChat>(_onConnect);
    on<DisconnectChat>(_onDisconnect);
    on<SendMessage>(_onSend);
    on<ReceiveMessage>(_onReceive);
    on<LoadChatHistory>(_onLoadHistory);
  }

  void _onConnect(ConnectChat event, Emitter<ChatState> emit) {
    socketService.connect();
    socketService.onPrivateMessage((data) {
      add(ReceiveMessage(data as Map<String, dynamic>));
    });
    emit(ChatConnected(messages));
  }

  void _onDisconnect(DisconnectChat event, Emitter<ChatState> emit) {
    socketService.disconnect();
    emit(ChatInitial());
  }

  void _onSend(SendMessage event, Emitter<ChatState> emit) {
    socketService.sendPrivateMessage(event.to, event.content);
    final msg = MessageModel(
      from: "me",
      content: event.content,
      timestamp: DateTime.now(),
    );
    messages.add(msg);
    emit(ChatConnected(List.from(messages)));
  }

  void _onReceive(ReceiveMessage event, Emitter<ChatState> emit) {
    final msg = MessageModel(
      from: event.data['from'],
      content: event.data['content'],
      timestamp: DateTime.parse(event.data['timestamp']),
    );
    messages.add(msg);
    emit(ChatConnected(List.from(messages)));
  }

  Future<void> _onLoadHistory(
    LoadChatHistory event,
    Emitter<ChatState> emit,
  ) async {
    messages = await ChatService.getMessagesWith(event.userId);
    emit(ChatConnected(List.from(messages)));
  }
}
