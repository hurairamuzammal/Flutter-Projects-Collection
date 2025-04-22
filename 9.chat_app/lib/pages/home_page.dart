import 'package:chat_app/components/user_title.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/drawer.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStreamExceptBlocked(),
      builder: (context, snapshot) {
        //if error
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        //if loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Loading...'));
        }
        // return list if data is available
        return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItems(userData, context))
                .toList());
      },
    );
  }

  // build user list
  Widget _buildUserListItems(
      Map<String, dynamic> userData, BuildContext context) {
    //display all users except the current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTitle(
          text: userData["email"],
          onTap: () {
            Navigator.push(
              context,
              //navigate to chat page
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  recieverID: userData["uid"],
                  receiverEmail: userData["email"],
                ),
              ),
            );
          });
    } else {
      return const SizedBox();
    }
  }
}
