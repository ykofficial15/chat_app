import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/chat/chat_bloc.dart';
import 'services/socket_service.dart';
import 'utils/storage.dart';
import 'views/login_view.dart';
import 'views/signup_view.dart';
import 'views/user_list_view.dart';
import 'views/chat_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => ChatBloc(SocketService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: light,
        initialRoute: AppStorage.getToken() == null ? "/login" : "/users",
        routes: {
          "/login": (_) => const LoginView(),
          "/signup": (_) => const SignupView(),
          "/users": (_) => const UserListView(),
          "/chat": (context) {
            final user = ModalRoute.of(context)!.settings.arguments as Map;
            return ChatView(user: user);
          },
        },
      ),
    );
  }
}
