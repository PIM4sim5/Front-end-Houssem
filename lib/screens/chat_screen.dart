import 'dart:developer';
import 'package:flutter_node_auth/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_node_auth/utils/constants.dart';
import 'package:flutter_node_auth/providers/models_provider.dart';
import 'package:flutter_node_auth/providers/chats_provider.dart';
import 'package:flutter_node_auth/services/api_service_add_message.dart';
import 'package:flutter_node_auth/models/message.dart';
import 'package:flutter_node_auth/services/assets_manager.dart';
import 'package:flutter_node_auth/widgets/chat_widget.dart';
import 'package:flutter_node_auth/widgets/text_widget.dart';
import '../main.dart'; 
import '../services/auth_services.dart';
import '../providers/user_provider.dart';
import './my_profile.dart';
import './home_page.dart'; // Importez votre fichier principal contenant la classe HomePage

class MessageCard extends StatelessWidget {
  
  final String message;
  final VoidCallback onPressed;

  const MessageCard({
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: onPressed,
          child: Text(message),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

   void signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text("Welcome to ChatDb"), // Updated title with user's name
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text("My Profile"),
                          onTap: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyProfileScreen()), // Navigate to MyProfileScreen
                            );
                          },
                        ),
                        ListTile(
                          title: Text("Sign Out"),
                          onTap: () {
                            signOutUser(context);
                          },
                        ),
                        ListTile(
                          title: Text("Chat"), // New "Chat" item
                          onTap: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Message cards
            MessageCard(
              message: 'I want to show something from the data base',
              onPressed: () {
                sendMessage('I want to show something from the data base', modelsProvider, chatProvider);
              },
            ),
            MessageCard(
              message: 'I want to insert something in the data base',
              onPressed: () {
                sendMessage('I want to insert something in the data base', modelsProvider, chatProvider);
              },
            ),
            MessageCard(
              message: 'I want to update something in the data base',
              onPressed: () {
                sendMessage('I want to update something in the data base', modelsProvider, chatProvider);
              },
            ),
            MessageCard(
              message: 'I want to delete something from the data base',
              onPressed: () {
                sendMessage('I want to delete something from the data base', modelsProvider, chatProvider);
              },
            ),
            // Message input field
            Expanded(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                    shouldAnimate: chatProvider.getChatList.length - 1 == index,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
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
                          await sendMessage(
                            value,
                            modelsProvider,
                            chatProvider,
                          );
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessage(
                          textEditingController.text,
                          modelsProvider,
                          chatProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   sendMessage(String message, ModelsProvider modelsProvider, ChatProvider chatProvider) {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You can't send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isTyping = true;
      chatProvider.addUserMessage(msg: message);
      textEditingController.clear();
      focusNode.unfocus();
    });

    // Sending message to API
    ApiService.addMessage(Message(content: message)).then((_) {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }).catchError((error) {
      log("error $error");
    });
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }
}
