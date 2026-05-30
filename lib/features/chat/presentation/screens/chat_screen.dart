import 'package:flutter/material.dart';

import '../widgets/chat_arc_banner.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5635A8),
              Color(0xFF0D1B3E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const ChatHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const ChatArcBanner(),

                      const SizedBox(height: 32),

                      Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: const Text(
                          'Messages will appear here',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const ChatInputBar(),
            ],
          ),
        ),
      ),
    );
  }
}