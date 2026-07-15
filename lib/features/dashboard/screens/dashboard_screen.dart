import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/widgets/feature_card.dart';
import '../../walk_mode/screens/walk_mode_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  centerTitle: false,

  

  title: Row(
    children: [

      Image.asset(
        "assets/logo/sheshield_logo1.png",
        width: 38,
      ),

      const SizedBox(width: 10),

      const Text(
        "SheShield",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),

    ],
  ),

  actions: [

    IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.notifications_none_rounded,
        color: Colors.black87,
      ),
    ),

    const Padding(
      padding: EdgeInsets.only(right: 14),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFFEDE7F6),
        child: Icon(
          Icons.person,
          color: Colors.deepPurple,
        ),
      ),
    ),

  ],
),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Text(
                "Good Evening, Praneethha👋",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                r"Let's keep you safe today.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 28),

              GestureDetector(
  onLongPress: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🚨 SOS Triggered (Demo)"),
      ),
    );
  },
  
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),

    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xffFF5A5F),
          Color(0xffD32F2F),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      borderRadius: BorderRadius.circular(28),

      boxShadow: [
        BoxShadow(
          color: Colors.red.withOpacity(0.25),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    ),

    child: Column(
      children: [

        const Icon(
          Icons.shield_outlined,
          color: Colors.white,
          size: 52,
        ),

        const SizedBox(height: 18),

        const Text(
          "Emergency SOS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Your trusted contacts will\nbe alerted instantly.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),

          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              Icon(
                Icons.touch_app,
                color: Colors.red,
              ),

              SizedBox(width: 8),

              Text(
                "PRESS & HOLD",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

              const SizedBox(height: 25),

              Row(
                children: [

                  FeatureCard(
              title: "Walk Mode",
  subtitle: "RT protection",
  icon: Icons.directions_walk,
  color: Colors.deepPurple,
  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const WalkModeScreen(),
    ),
  );
},
),

                  FeatureCard(
  title: "Guardian",
  subtitle: "Trusted contacts",
  icon: Icons.people_alt_outlined,
  color: Colors.blue,
  onTap: () {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Add Guardian feature coming soon."),
    ),
  );
},
),
                ],
              ),

              Row(
                children: [

                  FeatureCard(
  title: "Volunteer",
  subtitle: "Quick help",
  icon: Icons.volunteer_activism,
  color: Colors.green,
  onTap: () {},
),

                  FeatureCard(
  title: "Fake Call",
  subtitle: "Quick escape",
  icon: Icons.call,
  color: Colors.orange,
  onTap: () {},
),

                ],
              ),

              Row(
                children: [

                  FeatureCard(
  title: "Safe Route",
  subtitle: "Safer navigation",
  icon: Icons.route,
  color: Colors.amber,
  onTap: () {},
),

                  FeatureCard(
  title: "Heat Map",
  subtitle: "Risk awareness",
  icon: Icons.map,
  color: Colors.teal,
  onTap: () {},
),

                ],
              ),
            ],
          ),
        ),
      ),
      
    );
    
  }
}