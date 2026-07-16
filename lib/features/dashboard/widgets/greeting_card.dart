import 'package:flutter/material.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6A5AE0),
            Color(0xFF8B7BFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [

          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.waving_hand_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 18),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Good Morning",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Rithick 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Stay safe today. We're with you.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}