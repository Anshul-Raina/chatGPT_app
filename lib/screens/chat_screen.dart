import 'dart:developer';

import 'package:chatgpt_app/constants/constants.dart';
import 'package:chatgpt_app/services/api_service.dart';
import 'package:chatgpt_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../models/chat_model.dart';
import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;
  TextEditingController textEditingController = TextEditingController();
  late FocusNode focusNode;
  late ScrollController listScrollController;
  @override
  void initState() {
    listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
          ),
        ],
        elevation: 2,
        title: const Text('ChatGPT'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: listScrollController,
                  itemCount: chatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      chatIndex: chatList[index].chatIndex,
                      msg: chatList[index].msg,
                    );
                  }),
            ),
            if (isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessages(modelsProvider: modelsProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessages(modelsProvider: modelsProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessages({required ModelsProvider modelsProvider}) async {
    try {
      String msg = textEditingController.text;
      setState(() {
        isTyping = true;
        chatList.add(
          ChatModel(msg: msg, chatIndex: 0),
        );
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: modelsProvider.getCurrentModel,
      ));
    } catch (e) {
      log("Error: $e");
    } finally {
      setState(() {
        scrollListToEnd();
        isTyping = false;
      });
    }
  }
}
