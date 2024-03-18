import 'package:flutter/material.dart';
import 'package:flutter_node_auth/providers/user_provider.dart';
import 'package:flutter_node_auth/services/auth_services.dart';
import 'my_profile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user.name} to ChatDb"), // Modifier le texte de la barre d'applications
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
                            Navigator.pop(context); // Fermer le dialogue
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyProfileScreen()), // Naviguer vers MyProfileScreen
                            );
                          },
                        ),
                        ListTile(
                          title: Text("Sign Out"),
                          onTap: () {
                            signOutUser(context);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20), // Ajout d'un espace vide
          ],
        ),
      ),
    );
  }
}
