import 'package:chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, i) => MessageBubble(
            chatDocs[i].get('text'),
            chatDocs[i].get('userName'),
            chatDocs[i].get('userImage'),
            chatDocs[i].get('userId') == user.uid,
            key: ValueKey(chatDocs[i].documentID),
          ),
        );
      },
    );
  }
}
