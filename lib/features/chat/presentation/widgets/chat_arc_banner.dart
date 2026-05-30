import 'package:flutter/material.dart';

class ChatArcBanner extends StatelessWidget {
  const ChatArcBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.history,
            color: Colors.white70,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Session context will appear here',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}