import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String recieverID;

  const ChatPage(
      {super.key, required this.receiverEmail, required this.recieverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final playerA = AudioPlayer();

  // For text field focus
  final FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 600), () {
          scrollDown();
        });
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> playAudio1() async {
    await playerA.play(AssetSource('tone_1.mp3'));
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      String message = messageController.text;
      messageController.clear();
      playAudio1();
      await _chatService.sendMessage(widget.recieverID, message);
      scrollDown();
      // Play audio tone 1
    }
  }

  Future<void> playAudio2() async {
    await playerA.play(AssetSource('tone_2.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      //use the user theme stored in firebase
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          Row(
            children: [
              Expanded(child: buildUserInput()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    final senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.recieverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...'));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No messages',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20)));
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollDown();
            if (snapshot.data!.docs.isNotEmpty) {
              QueryDocumentSnapshot lastMessageData = snapshot.data!.docs.last;
              Map<String, dynamic> lastMessage =
                  lastMessageData.data() as Map<String, dynamic>;
              if (lastMessage["senderID"] != senderID) {
                playAudio2();
              }
            }
          });

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map<Widget>(
                    (messageData) => _buildMessageItem(messageData, senderID))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot messageData, String currentUserId) {
    Map<String, dynamic> data = messageData.data() as Map<String, dynamic>;
    bool isCurrentUser = data["senderID"] == currentUserId;

    // Compute the chatRoomId
    List<String> ids = [currentUserId, widget.recieverID];
    ids.sort();
    String chatRoomId = ids.join('_');

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ChatBubble(
          message: data["message"],
          messageId: messageData.id,
          userId: data["senderID"],
          chatRoomId: chatRoomId, // Pass chatRoomId to ChatBubble
          isCurrentUser: isCurrentUser,
        ),
      ],
    );
  }

  Widget buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 5),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              controller: messageController,
              hintText: 'Enter message',
              focusNode: myFocusNode,
              obsure: false,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: sendMessage,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
