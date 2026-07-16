import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../screens/incoming_call_screen.dart';
import '../services/fake_call_service.dart';
class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Fake Call"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 20),

            const Icon(
              Icons.phone_in_talk_rounded,
              size: 90,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 20),

            const Text(
              "Fake Incoming Call",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Use this feature to simulate an incoming call when you need a safe reason to leave an uncomfortable situation.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Mom",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text("Incoming caller"),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const ListTile(
                leading: Icon(Icons.timer),
                title: Text("Delay"),
                subtitle: Text("2 Seconds"),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
               onPressed: () async {
  final service = FakeCallService();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Fake call will start in 2 seconds..."),
      duration: Duration(seconds: 2),
    ),
  );

  await service.startFakeCall(
    delaySeconds: 2,
    onCallStart: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IncomingCallScreen(
            service: service,
            caller: service.defaultCaller,
          ),
        ),
      );
    },
  );
},
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  "START FAKE CALL",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}