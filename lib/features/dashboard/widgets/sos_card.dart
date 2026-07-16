// import 'package:flutter/material.dart';

// class SosCard extends StatelessWidget {
//   const SosCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPress: () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("🚨 SOS Triggered (Demo)"),
//           ),
//         );
//       },

//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(24),

//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [
//               Color(0xFFE53935),
//               Color(0xFFD32F2F),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),

//           borderRadius: BorderRadius.circular(28),

//           boxShadow: [
//             BoxShadow(
//               color: Colors.red.withOpacity(0.30),
//               blurRadius: 20,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),

//         child: const Column(
//           children: [

//             Icon(
//               Icons.emergency,
//               color: Colors.white,
//               size: 52,
//             ),

//             SizedBox(height: 14),

//             Text(
//               "EMERGENCY SOS",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),

//             SizedBox(height: 10),

//             Text(
//               "Press & Hold to alert your trusted guardians",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class SosCard extends StatelessWidget {
  const SosCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🚨 SOS Triggered (Demo)"),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE53935),
              Color(0xFFD32F2F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [

            const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 55,
            ),

            const SizedBox(height: 16),

            const Text(
              "EMERGENCY SOS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Protection Beyond an SOS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              "Press & Hold to instantly notify\nyour trusted guardians.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
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
    );
  }
}