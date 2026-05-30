import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const ChatHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white24,
              ),
            ),
            child: const Text(
              'No Arc Yet',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 12),

          CircleAvatar(
            backgroundColor: Colors.white10,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
