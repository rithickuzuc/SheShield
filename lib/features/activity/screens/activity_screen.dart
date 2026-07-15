import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
// import '../../../core/widgets/bottom_navbar.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Activity"),
        centerTitle: true,
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.history,
              size: 80,
              color: Colors.deepPurple,
            ),

            SizedBox(height: 20),

            Text(
              "No Activity Yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Your walk history and alerts\nwill appear here.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      
    );
  }
}