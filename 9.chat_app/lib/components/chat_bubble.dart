import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String chatRoomId;
  final String userId;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.messageId,
      required this.userId,
      required this.chatRoomId});
  // show options

  // show only delete option for current user
  void showOptions2(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.delete,
                      color: Theme.of(context).colorScheme.onPrimary),
                  title: Text("Delete",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteMessage(
                        context, chatRoomId, messageId); // Use chatRoomId
                  },
                ),
                // cancel button
                ListTile(
                  leading: Icon(Icons.cancel,
                      color: Theme.of(context).colorScheme.onPrimary),
                  title: Text("Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.flag,
                      color: Theme.of(context).colorScheme.onPrimary),
                  title: Text("Report",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  onTap: () {
                    // report message
                    Navigator.pop(context);
                    _reportMessage(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block,
                      color: Theme.of(context).colorScheme.onPrimary),
                  title: Text("Block",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  onTap: () {
                    // block message
                    Navigator.pop(context);
                    _blockUser(context, userId);
                  },
                ),
                // cancel button
                ListTile(
                  leading: Icon(Icons.cancel,
                      color: Theme.of(context).colorScheme.onPrimary),
                  title: Text("Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  //report message
  void _reportMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Report Message",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        content: Text("Are you sure you want to report this message?",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              ChatService().reportUser(messageId, userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  content: Text("Message reported successfully",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary))));
            },
            child: const Text("Report", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // delete message
  void _deleteMessage(
      BuildContext context, String messageId, String chatRoomId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Delete Message",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        content: Text("Are you sure you want to delete this message?",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
              onPressed: () {
                ChatService().deleteMessage(messageId, chatRoomId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    content: Text(
                      "Message deleted successfully",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    )));
                // also update the chat screen after deleting the message
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  //block message
  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Block User",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        content: Text("Are you sure you want to block this user?",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              ChatService().blockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  content: Text(
                    "User blocked successfully",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              );
            },
            child: const Text("Block", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return GestureDetector(
      onLongPress: () {
        // delete option will be added here
        if (!isCurrentUser) {
          showOptions(context);
        } else {
          showOptions2(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Colors.green[600]
              : isDarkMode
                  ? Colors.grey[800]
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(message,
            style: TextStyle(
              color: isCurrentUser
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimary,
            )),
      ),
    );
  }
}
