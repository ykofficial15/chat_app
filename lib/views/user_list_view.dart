import 'package:chat_app/utils/storage.dart';
import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  List<Map> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final fetched = await ChatService.getUsers();
    setState(() => users = fetched);
  }

  Future<void> _logout() async {
    await AppStorage.clear();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              "Chat App",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: false,
            expandedHeight: 100,
            backgroundColor: Theme.of(context).primaryColor,
            stretch: false,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: _logout,
              ),
            ],
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
          SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              return Container(
                margin: EdgeInsets.only(top: 0, bottom: 8, left: 16, right: 16),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.grey[100],
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(users[i]['email']),
                  onTap: () {
                    Navigator.pushNamed(context, "/chat", arguments: users[i]);
                  },
                ),
              );
            }, childCount: users.length),
          ),
        ],
      ),
    );
  }
}
