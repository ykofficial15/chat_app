import 'package:chat_app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/chat/chat_event.dart';
import '../blocs/chat/chat_state.dart';

class ChatView extends StatefulWidget {
  final Map user;
  const ChatView({super.key, required this.user});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final chatBloc = context.read<ChatBloc>();
    chatBloc.add(ConnectChat());
    chatBloc.add(LoadChatHistory(widget.user['id']));
  }

  @override
  void dispose() {
    context.read<ChatBloc>().add(DisconnectChat());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// SliverAppBar for consistent UI
          SliverAppBar(
            expandedHeight: 100,
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              widget.user['email'],
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 30),
              child: Container(
                height: 30,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),

          /// Chat body
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                /// Messages list
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (_, state) {
                      if (state is ChatConnected) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: state.messages.length,
                          itemBuilder: (_, i) {
                            final msg = state.messages[i];
                            debugPrint(msg.from);
                            final isMe = msg.from == AppStorage.getUserId();
                            return Align(
                              alignment:
                                  isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 14,
                                ),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isMe
                                          ? Theme.of(
                                            context,
                                          ).primaryColor.withOpacity(
                                            0.2,
                                          ) // your message color
                                          : Colors
                                              .grey
                                              .shade200, // other message color
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                    bottomLeft:
                                        isMe
                                            ? const Radius.circular(12)
                                            : const Radius.circular(0),
                                    bottomRight:
                                        isMe
                                            ? const Radius.circular(0)
                                            : const Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      isMe
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.content,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            isMe
                                                ? Colors.black
                                                : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isMe
                                          ? "You"
                                          : DateFormat(
                                            'hh:mm a, dd MMM',
                                          ).format(msg.timestamp),
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),

                /// Message input
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: "Type a message...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              context.read<ChatBloc>().add(
                                SendMessage(
                                  widget.user['id'],
                                  _controller.text,
                                ),
                              );
                              final chatBloc = context.read<ChatBloc>();
                              chatBloc.add(LoadChatHistory(widget.user['id']));
                              _controller.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
