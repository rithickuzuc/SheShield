import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const SizedBox(height: 10),

          const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.deepPurple,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 60,
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "Rithick P",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              "SheShield User",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const SizedBox(height: 35),

          _buildTile(
            Icons.phone,
            "Emergency Contacts",
          ),

          _buildTile(
            Icons.location_on,
            "Location Sharing",
          ),

          _buildTile(
            Icons.lock,
            "Privacy",
          ),

          _buildTile(
            Icons.info_outline,
            "About",
          ),

          _buildTile(
            Icons.logout,
            "Logout",
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.deepPurple,
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}