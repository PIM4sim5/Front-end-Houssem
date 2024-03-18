import 'package:flutter/material.dart';
import '../services/auth_services.dart'; // Importez votre service Flutter ici

class ActivationCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activation du compte'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Veuillez saisir l\'adresse e-mail et le code d\'activation :',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ActivationCodeForm(), // Afficher le formulaire de saisie du code d'activation
          ],
        ),
      ),
    );
  }
}

class ActivationCodeForm extends StatefulWidget {
  @override
  _ActivationCodeFormState createState() => _ActivationCodeFormState();
}

class _ActivationCodeFormState extends State<ActivationCodeForm> {
  final _emailController = TextEditingController();
  final _activationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Adresse e-mail',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _activationCodeController,
            decoration: InputDecoration(
              labelText: 'Code d\'activation',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Appeler la méthode d'activation avec les données saisies
              AuthService().activateAccount(
                context: context,
                email: _emailController.text,
                activationCode: _activationCodeController.text,
              );
            },
            child: Text('Valider'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _activationCodeController.dispose();
    super.dispose();
  }
}
