import '../models/guardian_model.dart';
import '../services/guardian_service.dart';

class GuardianController {
  final GuardianService service = GuardianService();

  List<GuardianModel> get guardians => service.getGuardians();

  void addGuardian(GuardianModel guardian) {
    service.addGuardian(guardian);
  }

  void updateGuardian(int index, GuardianModel guardian) {
    service.updateGuardian(index, guardian);
  }

  void deleteGuardian(int index) {
    service.deleteGuardian(index);
  }
}