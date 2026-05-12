import 'package:flutter/material.dart';
 
void main() {
  runApp(const MindSpaceApp());
}
 
class MindSpaceApp extends StatelessWidget {
  const MindSpaceApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080714),
      ),
      home: const ChatScreen(),
    );
  }
}
 
class ChatMessage {
  final String text;
  final bool isAI;
  const ChatMessage({required this.text, required this.isAI});
}
 
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
 
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
 
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
 
  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: "Hello! I'm here to listen. What's on your mind today?",
      isAI: true,
    ),
    const ChatMessage(text: "hello I'm sad", isAI: false),
    const ChatMessage(
      text:
          "I hear you. That sounds really challenging. Can you tell me more about what's making you feel this way?",
      isAI: true,
    ),
  ];
 
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isAI: false));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080714),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4A2D8A).withOpacity(0.5),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildMessageList()),
                _buildFinishBar(),
                _buildInputBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.close, color: Colors.white70, size: 22),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF5B3FD4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'transcription',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'analyse',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          const Spacer(),
          const Icon(Icons.more_vert, color: Colors.white54, size: 20),
        ],
      ),
    );
  }
 
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildBubble(_messages[index]);
      },
    );
  }
 
  Widget _buildBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: msg.isAI
              ? const Color(0xFF131129)
              : const Color(0xFF1E1A35),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isAI
                ? const Radius.circular(4)
                : const Radius.circular(16),
            bottomRight: msg.isAI
                ? const Radius.circular(16)
                : const Radius.circular(4),
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.07),
            width: 0.8,
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }
 
  Widget _buildFinishBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF131129),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 0.8,
              ),
            ),
            child: const Text(
              'finish',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
 
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF131129),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Tell me about your day...',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Icon(
              Icons.send_rounded,
              color: Colors.white.withOpacity(0.5),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
