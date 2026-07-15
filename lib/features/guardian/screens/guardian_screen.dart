import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/widgets/bottom_navbar.dart';
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

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

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

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add),
                label: const Text(
                  "ADD GUARDIAN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}