import 'package:flutter/material.dart';
import 'package:flutter_node_auth/custom_textfield.dart';
import 'package:flutter_node_auth/screens/signup_screen.dart';
import 'package:flutter_node_auth/services/auth_services.dart';
import 'package:flutter_node_auth/screens/newsletter-subscription.dart';
import 'ForgotPasswordScreen.dart';
import 'package:flutter_node_auth/screens/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void loginUser() {
    authService.signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image/avengers-logo.png",
                width: 400,
              ), // Ajout de l'image
              const SizedBox(height: 20),
              const Text(
                "Login",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: loginUser,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width / 2.5, 50),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20), // Ajout d'un espace entre les boutons
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text('Sign Up?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ForgotPasswordScreen(), // Naviguer vers la page de mot de passe oublié
                    ),
                  );
                },
                child: const Text('Forgot Password?'), // Ajouter le lien pour le mot de passe oublié
              ),

ElevatedButton( // Ajoutez un ElevatedButton pour naviguer vers la page newsletter_subscription.dart
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsletterSubscriptionPage(),
      ),
    );
  },
  child: const Text('Go to Newsletter Subscription'),
),


            ],
          ),
        ),
      ),
    );
  }
}
