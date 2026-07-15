import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../widgets/status_card.dart';

class WalkModeScreen extends StatelessWidget {
  const WalkModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Walk Mode"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Row(
                children: [

                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.shield,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Walk Mode Active",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Your journey is being monitored.",
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 24),

            const StatusCard(
              title: "Current Location",
              value: "Panimalar Engineering College",
              icon: Icons.location_on,
              color: Colors.red,
            ),

            const StatusCard(
              title: "Guardian",
              value: "Connected",
              icon: Icons.people,
              color: Colors.blue,
            ),

            const StatusCard(
              title: "Walking Time",
              value: "00:00:00",
              icon: Icons.timer,
              color: Colors.orange,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(Icons.stop_circle),

                label: const Text(
                  "STOP WALK MODE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}