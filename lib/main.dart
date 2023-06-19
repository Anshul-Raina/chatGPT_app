import 'package:chatgpt_app/providers/models_provider.dart';
import 'package:chatgpt_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ModelsProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundcolor,
            appBarTheme: AppBarTheme(
              color: cardColor,
            )),
        home: const ChatScreen(),
      ),
    );
  }
}
