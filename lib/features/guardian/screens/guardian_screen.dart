import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../widgets/guardian_tile.dart';

class GuardianScreen extends StatelessWidget {
  const GuardianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Guardians"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Trusted Guardians",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "Your trusted contacts for emergencies.",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 24),

        const GuardianTile(
          name: "Mother",
          phone: "+91 98765 43210",
          isOnline: true,
        ),

        const GuardianTile(
          name: "Father",
          phone: "+91 98765 12345",
          isOnline: true,
        ),

        const GuardianTile(
          name: "Brother",
          phone: "+91 98765 67890",
          isOnline: false,
        ),

        const SizedBox(height: 25),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Add Guardian feature coming soon."),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text(
              "ADD GUARDIAN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

      ],
    ),
  ),
),
    );
  }
}