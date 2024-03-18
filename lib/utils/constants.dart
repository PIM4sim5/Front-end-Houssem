import 'package:flutter/material.dart';
   String BASE_URL = "https://api.openai.com/v1";
   String  API_KEY= "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";






Color scaffoldBackgroundColor = const Color(0xFF343541);
Color cardColor = const Color(0xFF444654);

final chatMessages = [
  {
    "msg": "hello who are you ?",
    "chatIndex": 0,
    "response":
        "Hello, I am ChatDB . I am here to assist you with any information or questions you may have. How can I help you today?",
  },
  {
    "msg": "what is flutter ?",
    "chatIndex": 0,
    "response":
        "Flutter is an open-source mobile application development framework created by Google. It is used to develop applications for Android, iOS, Linux, Mac, Windows, and the web. Flutter uses the Dart programming language and allows for the creation of high-performance, visually attractive, and responsive apps. It also has a growing and supportive community, and offers many customizable widgets for building beautiful and responsive user interfaces.",
  },
  {
    "msg": "okay thanks",
    "chatIndex": 0,
    "response":
        "You're welcome! Let me know if you have any other questions or if there's anything else I can help you with.",
  },
];



class Constants {
  static String uri = 'https://back-end-houssem-rhy2.vercel.app';





}
