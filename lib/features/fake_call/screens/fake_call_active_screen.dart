import 'package:flutter/material.dart';

import '../models/caller_model.dart';
import 'dart:async';
import '../services/fake_call_service.dart';

class FakeCallActiveScreen extends StatefulWidget { 
final CallerModel caller;
final FakeCallService service;
  const FakeCallActiveScreen({
  super.key,
  required this.caller,
  required this.service,
});
  @override
State<FakeCallActiveScreen> createState() =>
    _FakeCallActiveScreenState();
}

class _FakeCallActiveScreenState
    extends State<FakeCallActiveScreen> {

 
  Timer? _timer;
Timer? _voiceTimer;

  int _seconds = 0;
  bool _speakerOn = false;
bool _muteOn = false;

  @override
void initState() {
  super.initState();

  // Start fake voice after the call connects
  _voiceTimer = Timer(
  const Duration(seconds: 2),
  () {
    if (mounted) {
      widget.service.playFakeVoice();
    }
  },
);

  // Start call timer
  _timer = Timer.periodic(
    const Duration(seconds: 1),
    (_) {
      setState(() {
        _seconds++;
      });
    },
  );
}
  @override
void dispose() {
  _timer?.cancel();
  _voiceTimer?.cancel();

  widget.service.stopAudio();

  super.dispose();
}

  String get formattedTime {

    final minutes = (_seconds ~/ 60)
        .toString()
        .padLeft(2, '0');

    final seconds = (_seconds % 60)
        .toString()
        .padLeft(2, '0');

    return "$minutes:$seconds";
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

              const SizedBox(height: 30),

              const Text(
                "Connected",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 18),

             Text(
  formattedTime,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 42,
    fontWeight: FontWeight.bold,
  ),
),

              const SizedBox(height: 55),

              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.deepPurple,
                child: Text(
                  widget.caller.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                widget.caller.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
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

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  _buildAction(
  icon: _muteOn ? Icons.mic_off : Icons.mic,
  title: "Mute",
  active: _muteOn,
  onTap: () {

    setState(() {
      _muteOn = !_muteOn;
    });

    
  },
),

_buildAction(
  icon: Icons.volume_up,
  title: "Speaker",
  active: _speakerOn,
  onTap: () {

    setState(() {
      _speakerOn = !_speakerOn;
    });

    
  },
),

_buildAction(
  icon: Icons.dialpad,
  title: "Keypad",
  active: false,
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Keypad coming next..."),
      ),
    );
  },
),
                ],
              ),

              const SizedBox(height: 45),

              GestureDetector(
                onTap: () async {
  await widget.service.stopAudio();

  if (mounted) {
    Navigator.pop(context);
  }
},
                child: Container(
                  height: 82,
                  width: 82,
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
                    size: 38,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "End Call",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction({
  required IconData icon,
  required String title,
  required bool active,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [

        AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          height: 60,
          width: 60,

          decoration: BoxDecoration(
            color: active
                ? Colors.deepPurple
                : Colors.white12,
            shape: BoxShape.circle,
          ),

          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}
}