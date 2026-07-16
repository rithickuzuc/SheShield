import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/widgets/feature_card.dart';
import '../../fake_call/screens/incoming_call_screen.dart';
import '../../walk_mode/screens/walk_mode_screen.dart';
import '../../guardian/screens/guardian_screen.dart';
import '../../fake_call/screens/fake_call_screen.dart';
import '../../safe_route/screens/safe_route_screen.dart';
import '../widgets/sos_card.dart';
import '../widgets/greeting_card.dart';class DashboardScreen extends StatelessWidget {
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

              const GreetingCard(),
              const SizedBox(height: 28),
              const SosCard(),

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
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const GuardianScreen(),
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
 onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const FakeCallScreen(),
    ),
  );
},
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
  onTap: (){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SafeRouteScreen(),
    ),
  );
  }
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