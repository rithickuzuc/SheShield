// import 'package:flutter/material.dart';

// import '../../../core/theme/app_color.dart';
// import '../models/guardian_model.dart';
// import '../services/guardian_service.dart';
// import '../widgets/guardian_tile.dart';
// import '../widgets/guardian_dialog.dart';
// class GuardianScreen extends StatefulWidget {
//   const GuardianScreen({super.key});

//   @override
//   State<GuardianScreen> createState() => _GuardianScreenState();
// }

// class _GuardianScreenState extends State<GuardianScreen> {

//   final GuardianService guardianService = GuardianService();

//   @override
//   Widget build(BuildContext context) {

//     final List<GuardianModel> guardians =
//         guardianService.getGuardians();

//     return Scaffold(
//       backgroundColor: AppColors.background,

//       appBar: AppBar(
//         title: const Text("Trusted Guardians"),
//         centerTitle: true,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             Text(
//               "Your trusted contacts for emergencies.",
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 16,
//               ),
//             ),

//             const SizedBox(height: 20),

//             Expanded(
//               child: ListView.builder(

//                 itemCount: guardians.length,

//                 itemBuilder: (context, index) {

//                   return GuardianTile(
//                     guardian: guardians[index],
//                   );

//                 },

//               ),
//             ),

//             SizedBox(
//               width: double.infinity,
//               height: 55,

//               child: ElevatedButton.icon(

//                 onPressed: () async {

//   final GuardianModel? guardian =
//       await showDialog<GuardianModel>(
//     context: context,
//     builder: (_) => const AddGuardianDialog(),
//   );

//   if (guardian != null) {
//     setState(() {
//       guardianService.addGuardian(guardian);
//     });
//   }
// },

//                 icon: const Icon(Icons.person_add),

//                 label: const Text(
//                   "ADD GUARDIAN",
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../models/guardian_model.dart';
import '../services/guardian_service.dart';
import '../widgets/guardian_dialog.dart';
import '../widgets/guardian_tile.dart';

class GuardianScreen extends StatefulWidget {
  const GuardianScreen({super.key});

  @override
  State<GuardianScreen> createState() => _GuardianScreenState();
}

class _GuardianScreenState extends State<GuardianScreen> {
  final GuardianService guardianService = GuardianService();

  @override
  Widget build(BuildContext context) {
    final List<GuardianModel> guardians = guardianService.getGuardians();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Trusted Guardians"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your trusted contacts for emergencies.",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
  child: guardians.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.people_outline,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "No Guardians Yet",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Add your trusted contacts\nfor emergency alerts.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      : ListView.builder(
          itemCount: guardians.length,
          itemBuilder: (context, index) {
            return GuardianTile(
              guardian: guardians[index],

              onEdit: () async {
                final GuardianModel? updatedGuardian =
                    await showDialog<GuardianModel>(
                  context: context,
                  builder: (_) => GuardianDialog(
                    guardian: guardians[index],
                  ),
                );

                if (updatedGuardian != null) {
                  setState(() {
                    guardianService.updateGuardian(
                      index,
                      updatedGuardian,
                    );
                  });
                }
              },

              onDelete: () async {
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Delete Guardian"),
                    content: Text(
                      "Are you sure you want to delete ${guardians[index].name}?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  setState(() {
                    guardianService.deleteGuardian(index);
                  });
                }
              },
            );
          },
        ),
),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text(
                  "ADD GUARDIAN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                onPressed: () async {
                  final GuardianModel? guardian =
                      await showDialog<GuardianModel>(
                    context: context,
                    builder: (_) => const GuardianDialog(),
                  );

                  if (guardian != null) {
  final bool alreadyExists = guardians.any(
    (g) => g.phone == guardian.phone,
  );

  if (alreadyExists) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("A guardian with this phone number already exists."),
      ),
    );
    return;
  }

  setState(() {
    guardianService.addGuardian(guardian);
  });
}
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}