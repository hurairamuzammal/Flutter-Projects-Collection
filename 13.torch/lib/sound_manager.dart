import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundManager {
  // Separate players avoid cutting sounds when toggling quickly
  static final AudioPlayer _onPlayer = AudioPlayer();
  static final AudioPlayer _offPlayer = AudioPlayer();
  // Preloaded audio bytes to eliminate first-play lag
  static Uint8List? _onBytes;
  static Uint8List? _offBytes;
  static bool _onSourceReady = false;
  static bool _offSourceReady = false;

  static bool _soundEnabled = true;
  static bool _initialized = false;

  static bool get soundEnabled => _soundEnabled;
  static set soundEnabled(bool enabled) => _soundEnabled = enabled;

  /// Call once during app startup to configure players.
  static Future<void> init() async {
    if (_initialized) return;
    try {
      // Configure players for short sound effects (no looping, no mixing issues)
      await _onPlayer.setReleaseMode(ReleaseMode.stop);
      await _offPlayer.setReleaseMode(ReleaseMode.stop);

      // Prefer a low-latency/sonification audio context
      final ctx = AudioContext(
        android: AudioContextAndroid(
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.assistanceSonification,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          isSpeakerphoneOn: false,
          stayAwake: false,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      );
      await _onPlayer.setAudioContext(ctx);
      await _offPlayer.setAudioContext(ctx);

      // Preload bytes so playback starts instantly and set as persistent sources
      final onData = await rootBundle.load('assets/sounds/on.mp3');
      final offData = await rootBundle.load('assets/sounds/off.mp3');
      _onBytes = onData.buffer.asUint8List();
      _offBytes = offData.buffer.asUint8List();
      try {
        await _onPlayer.setSource(BytesSource(_onBytes!));
        _onSourceReady = true;
      } catch (_) {
        try {
          await _onPlayer.setSource(AssetSource('assets/sounds/on.mp3'));
          _onSourceReady = true;
        } catch (_) {}
      }
      try {
        await _offPlayer.setSource(BytesSource(_offBytes!));
        _offSourceReady = true;
      } catch (_) {
        try {
          await _offPlayer.setSource(AssetSource('assets/sounds/off.mp3'));
          _offSourceReady = true;
        } catch (_) {}
      }
    } catch (_) {
      // Safe to ignore; platform may not support all configs
    }
    _initialized = true;
  }

  static Future<void> playClickSound() async {
    if (!_soundEnabled) return;
    // Fire-and-forget system click to avoid any UI blocking
    // ignore: unawaited_futures
    SystemSound.play(SystemSoundType.click);
  }

  static Future<void> _playAsset(
    AudioPlayer player,
    String primary, {
    String? fallback,
    Uint8List? bytes,
  }) async {
    try {
      // Ensure any previous playback is stopped before starting a new one
      await player.stop();
    } catch (_) {}

    // If bytes were preloaded, this is the fastest path
    if (bytes != null && bytes.isNotEmpty) {
      try {
        await player.play(BytesSource(bytes));
        return;
      } catch (_) {}
    }

    // Fallback: try the provided primary path; then optional fallback path.
    try {
      await player.play(AssetSource(primary));
      return;
    } catch (_) {}
    if (fallback != null) {
      try {
        await player.play(AssetSource(fallback));
        return;
      } catch (_) {}
    }

    // Last-resort fallback so the UI still provides feedback
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  static Future<void> playOnSound() async {
    if (!_soundEnabled) return;
    if (_onSourceReady) {
      try {
        // Quick restart from beginning without reloading source
        await _onPlayer.seek(Duration.zero);
        // Fire-and-forget resume; no need to block UI
        // ignore: unawaited_futures
        _onPlayer.resume();
        return;
      } catch (_) {}
    }
    // Fallback path
    // ignore: unawaited_futures
    _playAsset(
      _onPlayer,
      'assets/sounds/on.mp3',
      fallback: 'sounds/on.mp3',
      bytes: _onBytes,
    );
  }

  static Future<void> playOffSound() async {
    if (!_soundEnabled) return;
    if (_offSourceReady) {
      try {
        await _offPlayer.seek(Duration.zero);
        // ignore: unawaited_futures
        _offPlayer.resume();
        return;
      } catch (_) {}
    }
    // Fallback path
    // ignore: unawaited_futures
    _playAsset(
      _offPlayer,
      'assets/sounds/off.mp3',
      fallback: 'sounds/off.mp3',
      bytes: _offBytes,
    );
  }

  static Future<void> playModeChangeSound() async {
    if (!_soundEnabled) return;
    try {
      HapticFeedback.mediumImpact();
      // Subtle audible cue for mode change (fire-and-forget)
      // ignore: unawaited_futures
      SystemSound.play(SystemSoundType.alert);
    } catch (_) {
      // ignore
    }
  }

  static Future<void> dispose() async {
    try {
      await _onPlayer.dispose();
    } catch (_) {}
    try {
      await _offPlayer.dispose();
    } catch (_) {}
  }
}
