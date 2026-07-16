import '../models/guardian_model.dart';

class GuardianService {
  final List<GuardianModel> _guardians = [
    GuardianModel(
      name: "Mother",
      phone: "+91 98765 43210",
      isOnline: true,
    ),
    GuardianModel(
      name: "Father",
      phone: "+91 98765 12345",
      isOnline: true,
    ),
    GuardianModel(
      name: "Brother",
      phone: "+91 98765 67890",
      isOnline: false,
    ),
  ];

  List<GuardianModel> getGuardians() {
    return _guardians;
  }

  void addGuardian(GuardianModel guardian) {
    _guardians.add(guardian);
  }

  void deleteGuardian(int index) {
    _guardians.removeAt(index);
  }

  void updateGuardian(int index, GuardianModel guardian) {
    _guardians[index] = guardian;
  }
}