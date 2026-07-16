import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import '../models/caller_model.dart';

typedef VoidCallback = void Function();

class FakeCallService {
  final AudioPlayer _player = AudioPlayer();

  final CallerModel defaultCaller = const CallerModel(
    name: "Mom",
    phone: "+91 98765 43210",
    relationship: "Mother",
    image: "",
  );

  Future<void> startFakeCall({
    required int delaySeconds,
    required VoidCallback onCallStart,
  }) async {
    await Future.delayed(Duration(seconds: delaySeconds));

    final hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator == true) {
      Vibration.vibrate(duration: 1500);
    }

    await playRingtone();

    onCallStart();
  }

  Future<void> playRingtone() async {
    await _player.stop();

    await _player.setReleaseMode(ReleaseMode.loop);

    await _player.play(
      AssetSource("audio/ringtone.mp3"),
    );
  }

  Future<void> playFakeVoice() async {
    await _player.stop();

    await _player.setReleaseMode(ReleaseMode.release);

    await _player.play(
      AssetSource("audio/fake_voice.mp3"),
    );
  }

  Future<void> stopAudio() async {
    await _player.stop();
  }
}