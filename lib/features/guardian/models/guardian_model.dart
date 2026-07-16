class GuardianModel {
  final String name;
  final String phone;
  final bool isOnline;

  GuardianModel({
    required this.name,
    required this.phone,
    this.isOnline = true,
  });
}