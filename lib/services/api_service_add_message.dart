import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_node_auth/models/message.dart';

class ApiService {
  static const String baseUrl = '';

  static Future<void> addMessage(Message message) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message.toJson()),
      );

      if (response.statusCode == 201) {
        print('Message added successfully');
      } else {
        throw Exception('Failed to add message');
      }
    } catch (error) {
      print('Error adding message: $error');
      throw error;
    }
  }
}
