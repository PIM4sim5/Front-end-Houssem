import 'dart:convert';
import 'dart:html';
import 'package:flutter_node_auth/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/models/user.dart';
import 'package:flutter_node_auth/providers/user_provider.dart';
import 'package:flutter_node_auth/screens/home_screen.dart';
import 'package:flutter_node_auth/screens/login_screen.dart';
import 'package:flutter_node_auth/screens/signup_screen.dart';
import 'package:flutter_node_auth/utils/constants.dart';
import 'package:flutter_node_auth/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/activationCode.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }





void activateAccount({
  required BuildContext context,
  required String email,
  required String activationCode,
}) async {
  try {
    final navigator = Navigator.of(context);
    http.Response res = await http.post(
      Uri.parse('${Constants.uri}/api/activate'),
      body: jsonEncode({
        'email': email,
        'activationCode': activationCode,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Gérez la réponse en fonction du statut de la réponse
    switch (res.statusCode) {
      case 200:
        // Compte activé avec succès
        showSnackBar(context, 'Account activated successfully');
        // Vous pouvez effectuer une navigation vers une page de connexion ou toute autre page pertinente ici
        break;
      case 400:
        // Code d'activation incorrect
        showSnackBar(context, 'Incorrect activation code');
        break;
      case 404:
        // Utilisateur non trouvé
        showSnackBar(context, 'User not found');
        break;
      default:
        // Autre erreur non gérée
        showSnackBar(context, 'An unexpected error occurred');
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}















void signInUser({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  try {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    http.Response res = await http.post(
      Uri.parse('${Constants.uri}/api/signin'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Vérification de la réponse
    switch (res.statusCode) {
      case 200:
        // Connexion réussie
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userProvider.setUser(res.body);
        await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>  ChatScreen(),
          ),
          (route) => false,
        );
        break;
      case 401:
        // Compte non activé
        // Redirection vers ActivationCodePage()
        navigator.push(
          MaterialPageRoute(
            builder: (context) =>  ActivationCodePage(),
          ),
        );
        break;
      case 403:
        // Utilisateur inexistant
        showSnackBar(context, 'User with this email does not exist!');
        break;
      case 402:
        // Mot de passe incorrect
        showSnackBar(context, 'Incorrect password.');
        break;
      default:
        // Autre erreur non gérée
        showSnackBar(context, 'An unexpected error occurred.');
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}
















  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'x-auth-token': token},
        );

        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}
