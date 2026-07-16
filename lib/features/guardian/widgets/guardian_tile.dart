import 'package:flutter/material.dart';
import '../models/guardian_model.dart';
class GuardianTile extends StatelessWidget {
  final GuardianModel guardian;
final VoidCallback onEdit;
final VoidCallback onDelete;

  const GuardianTile({
    super.key,
    required this.guardian,

  required this.onEdit,

  required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: Text(
                    guardian.name[0],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                       guardian.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        guardian.phone,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [

                    Icon(
                      Icons.circle,
                      size: 12,
                      color: guardian.isOnline
                          ? Colors.green
                          : Colors.red,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      guardian.isOnline
                          ? "Online"
                          : "Offline",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: guardian.isOnline
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
  children: [
    Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Calling ${guardian.name}..."),
            ),
          );
        },
        icon: const Icon(Icons.call),
        label: const Text("Call"),
      ),
    ),

    const SizedBox(width: 12),

    IconButton(
      tooltip: "Message",
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Messaging ${guardian.name}..."),
          ),
        );
      },
      icon: const Icon(
        Icons.message,
        color: Colors.deepPurple,
      ),
    ),

    IconButton(
      tooltip: "Edit",
      onPressed: onEdit,
      icon: const Icon(
        Icons.edit,
        color: Colors.orange,
      ),
    ),

    IconButton(
      tooltip: "Delete",
      onPressed: onDelete,
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    ),
  ],
)         ],
        ),
      ),
    );
  }
}