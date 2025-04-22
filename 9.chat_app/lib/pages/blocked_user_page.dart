import 'package:chat_app/components/user_title.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUserPage extends StatelessWidget {
  BlockedUserPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  void showConfirmUnblockBox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text('Unblock User',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20)),
            content: Text('Are you sure you want to unblock this user?',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    _chatService.unblockUser(userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User unblocked successfully',
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onPrimary))));
                  },
                  child: const Text('Unblock',
                      style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String userId = _authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getBlockedUsersStream(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Loading...'));
            }

            final blockedUsers = snapshot.data ?? [];
            if (blockedUsers.isEmpty) {
              return Center(
                  child: Text('No blocked users',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20)));
            }

            return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return UserTitle(
                    text: user['email'],
                    onTap: () {
                      showConfirmUnblockBox(context, user['uid']);
                    });
              },
            );
          }),
    );
  }
}
