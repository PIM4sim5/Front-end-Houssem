class ChatModel {
  final String msg;
  final int chatIndex;

  ChatModel({required this.msg, required this.chatIndex});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      msg: json["msg"] as String? ??
          "", // Use type casting to ensure the value is a String
      chatIndex: json["chatIndex"] as int? ??
          0, // Use type casting to ensure the value is an int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'chatIndex': chatIndex,
    };
  }
}
