import 'package:flutter/material.dart';

import '../models/guardian_model.dart';

class GuardianDialog extends StatefulWidget {
  final GuardianModel? guardian;

  const GuardianDialog({
    super.key,
    this.guardian,
  });

  @override
  State<GuardianDialog> createState() => _GuardianDialogState();
}

class _GuardianDialogState extends State<GuardianDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.guardian != null) {
      nameController.text = widget.guardian!.name;
      phoneController.text = widget.guardian!.phone;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.guardian == null
            ? "Add Guardian"
            : "Edit Guardian",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Guardian Name",
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Phone Number",
             
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final phone = phoneController.text.trim();

            // Empty validation
            if (name.isEmpty || phone.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please fill all fields."),
                ),
              );
              return;
            }

            // Phone validation
            if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Phone number must contain exactly 10 digits.",
                  ),
                ),
              );
              return;
            }

            Navigator.pop(
              context,
              GuardianModel(
                name: name,
                phone: phone,
                isOnline: widget.guardian?.isOnline ?? true,
              ),
            );
          },
          child: Text(
            widget.guardian == null
                ? "Save"
                : "Update",
          ),
        ),
      ],
    );
  }
}