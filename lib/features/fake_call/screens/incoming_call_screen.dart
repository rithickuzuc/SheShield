
import 'package:flutter/material.dart';

import '../models/caller_model.dart';
import '../services/fake_call_service.dart';
import 'fake_call_active_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  final FakeCallService service;
  final CallerModel caller;

  const IncomingCallScreen({
    super.key,
    required this.service,
    required this.caller,
  });

  @override
  State<IncomingCallScreen> createState() =>
      _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _declineCall() async {
    await widget.service.stopAudio();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _acceptCall() async {
  await widget.service.stopAudio();

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => FakeCallActiveScreen(
        caller: widget.caller,
        service: widget.service,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101114),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 24),

              const Text(
                "Calling...",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 70),

              ScaleTransition(
                scale: _animation,
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(.45),
                        blurRadius: 35,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 90,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Text(
                widget.caller.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.caller.phone,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.caller.relationship,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 16,
                ),
              ),

              const Spacer(),

              Row(
  children: [
    Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: _declineCall,
            child: Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(.45),
                    blurRadius: 18,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Decline",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),

    const SizedBox(width: 80),

    Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: _acceptCall,
            child: Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(.45),
                    blurRadius: 18,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.call,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Accept",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  ],
),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}