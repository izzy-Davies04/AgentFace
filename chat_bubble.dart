import 'package:flutter/material.dart';
import '../models/animal_config.dart';

enum MessageRole { user, agent }

class ChatMessage {
  final String text;
  final MessageRole role;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.role}) : timestamp = DateTime.now();
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final AnimalConfig animal;

  const ChatBubble({super.key, required this.message, required this.animal});

  @override
  Widget build(BuildContext context) {
    final isAgent = message.role == MessageRole.agent;
    return Align(
      alignment: isAgent ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 290),
        decoration: BoxDecoration(
          color: isAgent
              ? animal.primaryColor.withOpacity(0.15)
              : const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isAgent ? 4 : 16),
            bottomRight: Radius.circular(isAgent ? 16 : 4),
          ),
          border: Border.all(
            color: isAgent ? animal.primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isAgent ? animal.primaryColor.withOpacity(0.95) : Colors.white.withOpacity(0.88),
            fontSize: 13.5,
            height: 1.45,
            fontFamily: 'Courier',
          ),
        ),
      ),
    );
  }
}
