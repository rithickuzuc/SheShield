import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

class SafeRouteScreen extends StatelessWidget {
  const SafeRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Safe Route"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Find the Safest Route",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Navigate through safer roads with confidence.",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.my_location),
                hintText: "Current Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                hintText: "Destination",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              height: 220,
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.map,
                    size: 70,
                    color: Colors.deepPurple,
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Google Maps will appear here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Finding safest route...",
                      ),
                    ),
                  );
                },

                icon: const Icon(Icons.navigation),

                label: const Text(
                  "START NAVIGATION",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}