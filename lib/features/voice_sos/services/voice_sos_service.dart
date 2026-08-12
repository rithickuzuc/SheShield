import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef VoiceSosCallback = void Function(String command);

class VoiceSosService {
  final SpeechToText _speechToText = SpeechToText();

  bool _isAvailable = false;
  bool _isListening = false;
  bool _shouldKeepListening = false;
  bool _restartScheduled = false;

  VoiceSosCallback? _onCommandDetected;

  Future<bool> initialize({
    required VoiceSosCallback onCommandDetected,
  }) async {
    _onCommandDetected = onCommandDetected;

    try {
      _isAvailable = await _speechToText.initialize(
        onStatus: _onStatus,
        onError: _onError,
      );

      debugPrint(
        "VOICE: initialized = $_isAvailable",
      );

      return _isAvailable;
    } catch (e) {
      debugPrint(
        "VOICE INITIALIZATION ERROR: $e",
      );

      _isAvailable = false;

      return false;
    }
  }

  Future<void> startListening() async {
    if (!_isAvailable) {
      debugPrint("VOICE: Speech recognition unavailable.");
      return;
    }

    if (_isListening) {
      return;
    }

    _shouldKeepListening = true;

    await _startRecognition();
  }

  Future<void> _startRecognition() async {
    if (!_isAvailable ||
        !_shouldKeepListening ||
        _isListening) {
      return;
    }

    try {
      _isListening = true;

      debugPrint("VOICE: Starting recognition...");

      await _speechToText.listen(
        onResult: (result) {
          final String words =
              result.recognizedWords
                  .toLowerCase()
                  .trim();

          if (words.isEmpty) {
            return;
          }

          debugPrint(
            "VOICE HEARD: $words",
          );

          _checkForEmergencyCommand(words);
        },

        localeId: "en_US",

        listenFor: const Duration(
          seconds: 30,
        ),

        pauseFor: const Duration(
          seconds: 3,
        ),

        partialResults: true,

        cancelOnError: false,
      );
    } catch (e) {
      debugPrint(
        "VOICE LISTEN ERROR: $e",
      );

      _isListening = false;

      _scheduleRestart();
    }
  }

  void _checkForEmergencyCommand(
    String words,
  ) {
    final String normalized =
        words.toLowerCase().trim();

    // Emergency commands
    const emergencyCommands = [
      "help",
      "help me",
      "danger",
      "emergency",
      "sos",
      "save me",
      "someone help",
      "please help",
      "i need help",
    ];

    for (final command in emergencyCommands) {
      if (normalized.contains(command)) {
        debugPrint(
          "VOICE EMERGENCY COMMAND DETECTED: $command",
        );

        _onCommandDetected?.call(
          "emergency",
        );

        return;
      }
    }

    // Stop command
    const stopCommands = [
      "stop",
      "stop sos",
      "cancel sos",
      "cancel emergency",
    ];

    for (final command in stopCommands) {
      if (normalized.contains(command)) {
        debugPrint(
          "VOICE STOP COMMAND DETECTED: $command",
        );

        _onCommandDetected?.call(
          "stop",
        );

        return;
      }
    }
  }

  void _onStatus(
    String status,
  ) {
    debugPrint(
      "VOICE STATUS: $status",
    );

    if (status == "listening") {
      _isListening = true;
      return;
    }

    if (status == "done" ||
        status == "notListening") {
      _isListening = false;

      if (_shouldKeepListening) {
        _scheduleRestart();
      }
    }
  }

  void _onError(
    dynamic error,
  ) {
    debugPrint(
      "VOICE ERROR: $error",
    );

    _isListening = false;

    if (_shouldKeepListening) {
      _scheduleRestart();
    }
  }

  void _scheduleRestart() {
    if (_restartScheduled ||
        !_shouldKeepListening) {
      return;
    }

    _restartScheduled = true;

    Future.delayed(
      const Duration(
        milliseconds: 700,
      ),
      () async {
        _restartScheduled = false;

        if (!_shouldKeepListening) {
          return;
        }

        if (_isListening) {
          return;
        }

        await _startRecognition();
      },
    );
  }

  Future<void> stopListening() async {
    _shouldKeepListening = false;
    _restartScheduled = false;
    _isListening = false;

    try {
      await _speechToText.stop();
    } catch (_) {}
  }

  Future<void> cancelListening() async {
    _shouldKeepListening = false;
    _restartScheduled = false;
    _isListening = false;

    try {
      await _speechToText.cancel();
    } catch (_) {}
  }

  bool get isListening => _isListening;

  bool get isAvailable => _isAvailable;
}