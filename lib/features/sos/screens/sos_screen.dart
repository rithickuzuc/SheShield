import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/theme/app_color.dart';
import '../../guardian/models/guardian_model.dart';
import '../../guardian/services/guardian_service.dart';
import '../services/sos_service.dart';
import '../../voice_sos/services/voice_sos_service.dart';

class SosScreen extends StatefulWidget {
  final bool startActive;

  const SosScreen({
    super.key,
    this.startActive = false,
  });

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final SosService _sosService = SosService();
  final GuardianService _guardianService = GuardianService();

  Timer? _countdownTimer;

  int _countdown = 5;

  bool _isCountingDown = false;
  bool _sosActive = false;

  bool _isGettingLocation = false;
  bool _locationReady = false;

  String? _locationError;

  Position? _currentPosition;
  String? _locationLink;

  List<GuardianModel> _guardians = [];
  final VoiceSosService _voiceSosService =
    VoiceSosService();
  bool _voiceListeningEnabled = false;

  
  @override
void initState() {
  super.initState();

  _sosActive = widget.startActive;

  _guardians = _guardianService.getGuardians();

  _initializeVoiceSos();

  if (widget.startActive) {
    Future.microtask(_activateSos);
  }
}

  
 @override
void dispose() {
  _countdownTimer?.cancel();
  _voiceSosService.stopListening();
  super.dispose();
}

  // ============================================================
  // START SOS
  // ============================================================
Future<void> _initializeVoiceSos() async {
  final available =
      await _voiceSosService.initialize(
    onCommandDetected: _handleVoiceCommand,
  );

  if (!mounted) return;

  if (available) {
    setState(() {
      _voiceListeningEnabled = true;
    });

    await _voiceSosService.startListening();
  }
}
void _handleVoiceCommand(String command) {
  if (!mounted) return;

  final String text = command.toLowerCase().trim();

  if (text == "emergency" ||
      text == "help" ||
      text == "danger" ||
      text == "scream" ||
      text == "save me") {
    _triggerVoiceSos();
    return;
  }

  if (text == "stop") {
    _stopVoiceSos();
  }
}

void _stopVoiceSos() {
  if (!_isCountingDown && !_sosActive) {
    return;
  }

  if (_isCountingDown) {
    _cancelSos();
    return;
  }

  if (_sosActive) {
    _stopSos();
  }
}
  void _startSos() {
    if (_isCountingDown || _sosActive) {
      return;
    }

    setState(() {
      _countdown = 5;
      _isCountingDown = true;
    });

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_countdown > 1) {
          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel();

          setState(() {
            _countdown = 0;
            _isCountingDown = false;
            _sosActive = true;
          });

          _activateSos();
        }
      },
    );
  }
  

Future<void> _triggerVoiceSos() async {

  if (_sosActive) {

    return;

  }

  _countdownTimer?.cancel();

  setState(() {

    _countdown = 0;

    _isCountingDown = false;

    _sosActive = true;

  });

  await _activateSos();

  if (!mounted) return;

  _guardians = _guardianService.getGuardians();

  if (_guardians.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(

          "SOS activated, but no trusted guardians are added.",

        ),

        behavior: SnackBarBehavior.floating,

      ),

    );

    return;

  }

  if (!_locationReady || _locationLink == null) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(

          "SOS activated. Waiting for location...",

        ),

        behavior: SnackBarBehavior.floating,

      ),

    );

    return;

  }

  final String message =

      _sosService.createEmergencyMessage(

    locationLink: _locationLink!,

  );

  final GuardianModel guardian = _guardians.first;

  try {

    await _sosService.openSms(

      phoneNumber: guardian.phone,

      message: message,

    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(

          "Emergency message prepared for ${guardian.name}.",

        ),

        behavior: SnackBarBehavior.floating,

      ),

    );

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(

          e.toString().replaceFirst(

            "Exception: ",

            "",

          ),

        ),

        behavior: SnackBarBehavior.floating,

      ),

    );

  }

}

  // ============================================================
  // CANCEL COUNTDOWN
  // ============================================================

  void _cancelSos() {
    _countdownTimer?.cancel();

    setState(() {
      _countdown = 5;
      _isCountingDown = false;
    });
  }

  // ============================================================
  // ACTIVATE SOS + GET LOCATION
  // ============================================================

  Future<void> _activateSos() async {
    if (!mounted) return;

    setState(() {
      _sosActive = true;
      _isGettingLocation = true;
      _locationReady = false;
      _locationError = null;
    });

    // Refresh guardians in case the user added/edited one.
    _guardians = _guardianService.getGuardians();

    try {
      final Position position =
          await _sosService.getCurrentLocation();

      final String locationLink =
          _sosService.createLocationLink(position);

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _locationLink = locationLink;
        _locationReady = true;
        _isGettingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isGettingLocation = false;
        _locationReady = false;

        _locationError = e
            .toString()
            .replaceFirst(
              "Exception: ",
              "",
            );
      });
    }
  }

  // ============================================================
  // ALERT GUARDIANS
  // ============================================================

  Future<void> _alertGuardians() async {
    if (!_locationReady || _locationLink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Waiting for your location...",
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    if (_guardians.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No trusted guardians added.",
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    final GuardianModel? selectedGuardian =
        await showModalBottomSheet<GuardianModel>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildGuardianSelector();
      },
    );

    if (selectedGuardian == null) {
      return;
    }

    final String message =
        _sosService.createEmergencyMessage(
      locationLink: _locationLink!,
    );

    try {
      await _sosService.openSms(
        phoneNumber: selectedGuardian.phone,
        message: message,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Opening message for ${selectedGuardian.name}",
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              "Exception: ",
              "",
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _callGuardian() async {
  if (_guardians.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "No trusted guardians added.",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    return;
  }

  final GuardianModel? selectedGuardian =
      await showModalBottomSheet<GuardianModel>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _buildCallGuardianSelector();
    },
  );

  if (selectedGuardian == null) {
    return;
  }

  try {
    await _sosService.callGuardian(
      selectedGuardian.phone,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Calling ${selectedGuardian.name}...",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString().replaceFirst(
            "Exception: ",
            "",
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

  // ============================================================
  // GUARDIAN SELECTOR
  // ============================================================

  Widget _buildGuardianSelector() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        30,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 45,

              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius:
                    BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            const Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 28,
                ),

                SizedBox(width: 12),

                Text(
                  "Alert Guardian",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose a trusted contact to receive your emergency location.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ..._guardians.map(
              (guardian) {
                return _buildGuardianOption(
                  guardian,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallGuardianSelector() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        30,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 45,

              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            const Row(
              children: [
                Icon(
                  Icons.phone_rounded,
                  color: Colors.green,
                  size: 28,
                ),

                SizedBox(width: 12),

                Text(
                  "Call Guardian",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose a trusted contact to call directly.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ..._guardians.map(
              (guardian) {
                return _buildCallGuardianOption(guardian);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallGuardianOption(GuardianModel guardian) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.black.withOpacity(0.06),
        ),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),

        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green.shade100,

          child: Text(
            guardian.name.isNotEmpty
                ? guardian.name[0].toUpperCase()
                : "?",

            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        title: Text(
          guardian.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),

        subtitle: Text(guardian.phone),

        trailing: const Icon(
          Icons.phone_rounded,
          color: Colors.green,
        ),

        onTap: () {
          Navigator.pop(context, guardian);
        },
      ),
    );
  }

  Widget _buildGuardianOption(
    GuardianModel guardian,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.black.withOpacity(
            0.06,
          ),
        ),
      ),

      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),

        leading: CircleAvatar(
          radius: 25,

          backgroundColor:
              Colors.deepPurple.shade100,

          child: Text(
            guardian.name.isNotEmpty
                ? guardian.name[0]
                    .toUpperCase()
                : "?",

            style: const TextStyle(
              color: Colors.deepPurple,
              fontWeight:
                  FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        title: Text(
          guardian.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),

        subtitle: Text(
          guardian.phone,
        ),

        trailing: const Icon(
          Icons.message_outlined,
          color: Colors.deepPurple,
        ),

        onTap: () {
          Navigator.pop(
            context,
            guardian,
          );
        },
      ),
    );
  }

  // ============================================================
  // STOP SOS
  // ============================================================

  void _stopSos() {
    _countdownTimer?.cancel();

    setState(() {
      _sosActive = false;
      _countdown = 5;

      _isGettingLocation = false;
      _locationReady = false;

      _locationError = null;
      _currentPosition = null;
      _locationLink = null;
    });

    Navigator.pop(context);
  }

  // ============================================================
  // MAIN UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Emergency SOS",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: AnimatedSwitcher(
          duration:
              const Duration(
            milliseconds: 350,
          ),

          child: _sosActive
              ? _buildActiveSos()
              : _buildSosHome(),
        ),
      ),
    );
  }

  // ============================================================
  // SOS HOME
  // ============================================================

 Widget _buildSosHome() {
  return SingleChildScrollView(
    key: const ValueKey(
      "sos_home",
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 20,
    ),

    child: Column(
      children: [

        if (_voiceListeningEnabled)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mic_rounded,
                  size: 16,
                  color: Colors.green.shade600,
                ),

                const SizedBox(width: 6),

                Text(
                  "Voice safety active",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 10),

        const Text(
          "Need Help?",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          _isCountingDown
              ? "SOS will activate automatically"
              : "Press the button in an emergency",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 45),

        _buildSosButton(),

        const SizedBox(height: 35),

        if (_isCountingDown)
          _buildCancelButton()
        else
          _buildSafetyInformation(),

        const SizedBox(height: 30),
      ],
    ),
  );
}

  // ============================================================
  // SOS BUTTON
  // ============================================================

  Widget _buildSosButton() {
    return GestureDetector(
      onTap: _isCountingDown
          ? null
          : _startSos,

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 250,
        ),

        height: 230,
        width: 230,

        decoration:
            BoxDecoration(
          shape: BoxShape.circle,

          color: _isCountingDown
              ? Colors.red.shade700
              : Colors.red.shade600,

          boxShadow: [
            BoxShadow(
              color:
                  Colors.red.withOpacity(
                0.28,
              ),

              blurRadius: 35,
              spreadRadius: 10,
            ),
          ],
        ),

        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              if (_isCountingDown) ...[
                Text(
                  "$_countdown",

                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize: 64,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const Text(
                  "SECONDS",

                  style:
                      TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ] else ...[
                const Icon(
                  Icons.sos_rounded,
                  color:
                      Colors.white,
                  size: 68,
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  "SOS",

                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize: 34,
                    fontWeight:
                        FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CANCEL COUNTDOWN
  // ============================================================

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,

      child:
          OutlinedButton.icon(
        onPressed:
            _cancelSos,

        icon: const Icon(
          Icons.close,
        ),

        label: const Text(
          "Cancel SOS",

          style: TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.w700,
          ),
        ),

        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              Colors.red.shade700,

          side: BorderSide(
            color:
                Colors.red.shade300,
            width: 1.5,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SAFETY INFORMATION
  // ============================================================

  Widget _buildSafetyInformation() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.06,
            ),

            blurRadius: 16,

            offset:
                const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.red.withOpacity(
                    0.10,
                  ),
                  shape:
                      BoxShape.circle,
                ),

                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.red,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Emergency Assistance",

                      style:
                          TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Text(
                      "Your trusted guardians can be alerted during an emergency.",

                      style:
                          TextStyle(
                        color:
                            Colors.black54,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          _buildInfoRow(
            Icons.location_on_outlined,
            "Location",
            "Your current location will be shared.",
          ),

          const SizedBox(
            height: 12,
          ),

          _buildInfoRow(
            Icons.people_outline,
            "Guardians",
            "Your trusted contacts will be notified.",
          ),

          const SizedBox(
            height: 12,
          ),

          _buildInfoRow(
            Icons.phone_outlined,
            "Emergency Call",
            "Emergency assistance can be contacted.",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: Colors.deepPurple,
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style:
                    const TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 2,
              ),

              Text(
                description,

                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIVE SOS
  // ============================================================

  Widget _buildActiveSos() {
    return SingleChildScrollView(
      key: const ValueKey(
        "sos_active",
      ),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 30,
      ),

      child: Column(
        children: [
          Container(
            height: 110,
            width: 110,

            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,

              color:
                  Colors.red.withOpacity(
                0.12,
              ),
            ),

            child: const Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 60,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          const Text(
            "SOS ACTIVE",

            style:
                TextStyle(
              color: Colors.red,
              fontSize: 30,
              fontWeight:
                  FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            "Emergency assistance has been activated.",

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color:
                  Colors.grey.shade600,
              fontSize: 16,
            ),
          ),

          const SizedBox(
            height: 35,
          ),

          _buildLocationStatus(),

          const SizedBox(
            height: 14,
          ),

          _buildActiveStatus(
            Icons.people,
            "Trusted Guardians",
            _guardians.isEmpty
                ? "No guardians added"
                : "${_guardians.length} trusted guardian${_guardians.length == 1 ? '' : 's'} available",
            showCheck:
                _guardians.isNotEmpty,
          ),

          const SizedBox(
            height: 14,
          ),

          _buildActiveStatus(
            Icons.notifications_active,
            "Emergency Alert",
            "SOS emergency state is active",
          ),

          const SizedBox(
            height: 30,
          ),

          // ----------------------------------------------------
          // ALERT GUARDIANS BUTTON
          // ----------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 58,

            child:
                ElevatedButton.icon(
              onPressed:
                  _locationReady &&
                          _guardians.isNotEmpty
                      ? _alertGuardians
                      : null,

              icon: const Icon(
                Icons.message_outlined,
              ),

              label: const Text(
                "ALERT GUARDIANS",

                style:
                    TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.deepPurple,

                foregroundColor:
                    Colors.white,

                disabledBackgroundColor:
                    Colors.grey.shade300,

                disabledForegroundColor:
                    Colors.grey.shade600,

                elevation: 3,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    17,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 14,
          ),
          const SizedBox(height: 14),

SizedBox(
  width: double.infinity,
  height: 58,
  child: OutlinedButton.icon(
    onPressed: _guardians.isNotEmpty
        ? _callGuardian
        : null,

    icon: const Icon(
      Icons.phone_in_talk_rounded,
    ),

    label: const Text(
      "CALL GUARDIAN",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    ),

    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.green.shade700,

      side: BorderSide(
        color: Colors.green.shade400,
        width: 1.5,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
    ),
  ),
),
          // ----------------------------------------------------
          // STOP SOS
          // ----------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 58,

            child:
                ElevatedButton.icon(
              onPressed:
                  _stopSos,

              icon: const Icon(
                Icons.stop_circle_outlined,
              ),

              label: const Text(
                "STOP SOS",

                style:
                    TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,

                foregroundColor:
                    Colors.white,

                elevation: 4,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    17,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            "Only stop SOS when you are safe.",

            style: TextStyle(
              color:
                  Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOCATION STATUS
  // ============================================================

  Widget _buildLocationStatus() {
    if (_isGettingLocation) {
      return _buildActiveStatus(
        Icons.location_searching,
        "Getting Location",
        "Finding your current position...",
        showCheck: false,
        showLoading: true,
      );
    }

    if (_locationReady &&
        _currentPosition != null) {
      return _buildActiveStatus(
        Icons.location_on,
        "Location Ready",
        "GPS coordinates captured successfully",
        showCheck: true,
      );
    }

    return _buildActiveStatus(
      Icons.location_off,
      "Location Unavailable",
      _locationError ??
          "Unable to get your current location",
      showCheck: false,
    );
  }

  // ============================================================
  // ACTIVE STATUS CARD
  // ============================================================

  Widget _buildActiveStatus(
    IconData icon,
    String title,
    String description, {
    bool showCheck = true,
    bool showLoading = false,
  }) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(17),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              Colors.red.withOpacity(
            0.10,
          ),
        ),
      ),

      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,

            decoration:
                BoxDecoration(
              color:
                  Colors.red.withOpacity(
                0.10,
              ),
              shape:
                  BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: Colors.red,
              size: 24,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  description,

                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          if (showLoading)
            const SizedBox(
              height: 20,
              width: 20,

              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          else if (showCheck)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 22,
            )
          else
            const Icon(
              Icons.error_outline,
              color: Colors.orange,
              size: 22,
            ),
        ],
      ),
    );
  }
}