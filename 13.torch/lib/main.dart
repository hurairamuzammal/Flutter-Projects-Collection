// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:torch_light/torch_light.dart';
import 'sound_manager.dart';
import 'dart:async';

// Set this to false in tests to avoid invoking platform channels.
// In your app it remains true so real hardware is used.
bool enableTorchHardware = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoundManager.init();
  runApp(const TorchApp());
}

class TorchApp extends StatelessWidget {
  const TorchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Torch',
      theme: ThemeData(
        // Google's Material dark theme colors
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.white70,
          surface: Color(0xFF121212), // Google's dark surface
          onSurface: Colors.white,
          background: Color(0xFF000000), // Pure black background
          onBackground: Colors.white,
          surfaceVariant: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF000000),
        useMaterial3: true,
      ),
      home: const TorchHome(),
    );
  }
}

enum TorchMode { normal, strobe, screenLight }

enum ScreenLightColor { white, red, green, blue, amber }

class TorchHome extends StatefulWidget {
  const TorchHome({super.key});

  @override
  State<TorchHome> createState() => _TorchHomeState();
}

class _TorchHomeState extends State<TorchHome> with TickerProviderStateMixin {
  Widget _buildFloatingModeButton(TorchMode mode, IconData icon, String label) {
    final isSelected = _currentMode == mode;
    return GestureDetector(
      onTap: () async {
        // Play mode change sound with haptic feedback
        await SoundManager.playModeChangeSound();
        _stopFlashPattern();
        _toggleTorch(false);
        // If leaving Screen Light mode, restore previous brightness
        if (_currentMode == TorchMode.screenLight) {
          await _restoreSystemBrightness();
        }
        setState(() {
          _currentMode = mode;
          _isOn = false;
          _showModeMenu = false;
        });
        _pulseController.stop();
        _pulseController.reset();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: (isSelected ? Colors.amber : Colors.black).withOpacity(
                0.3,
              ),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  bool _isOn = false;
  bool _isAvailable = !kIsWeb;
  String? _error;
  bool _isPatternRunning = false; // Track if SOS/Strobe pattern is running

  // Settings
  bool _soundEnabled = true;
  // Screen Light brightness (0.0-1.0), applied to system/app screen brightness
  double _screenBrightness = 1.0;
  // Strobe speed multiplier (0.5x - 2.0x)
  double _strobeSpeed = 1.0;
  bool _showSettings = false;
  bool _showModeMenu = false;

  // Modes
  TorchMode _currentMode = TorchMode.normal;
  ScreenLightColor _screenColor = ScreenLightColor.white;

  // Screen brightness tracking
  double? _systemBrightnessBeforeScreenLight;

  // Flash patterns
  Timer? _flashTimer;

  // Animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;
  // Removed unused background animation controller

  @override
  void initState() {
    super.initState();
    _checkAvailability();
    _setupAnimations();
    _initBrightness();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _menuController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _menuAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _menuController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initBrightness() async {
    try {
      final current = await ScreenBrightness().current;
      setState(() {
        _screenBrightness = (current).clamp(0.0, 1.0);
      });
    } catch (e) {
      // ignore; plugin may not be available on web or desktop
    }
  }

  Future<void> _applyScreenBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value.clamp(0.0, 1.0));
    } catch (e) {
      // ignore
    }
  }

  Future<void> _restoreSystemBrightness() async {
    if (_systemBrightnessBeforeScreenLight == null) return;
    try {
      await ScreenBrightness().setScreenBrightness(
        _systemBrightnessBeforeScreenLight!.clamp(0.0, 1.0),
      );
    } catch (e) {
      // ignore
    } finally {
      _systemBrightnessBeforeScreenLight = null;
    }
  }

  Future<void> _checkAvailability() async {
    _isAvailable = true;
    // if (!enableTorchHardware) return;
    // if (kIsWeb) {
    //   setState(() => _isAvailable = false);
    //   return;
    // }
    // try {
    //   final available = await TorchLight.isTorchAvailable();
    //   if (mounted) setState(() => _isAvailable = available);
    // } catch (e) {
    //   if (mounted) {
    //     setState(() {
    //       _isAvailable = false;
    //       _error = e.toString();
    //     });
    //   }
    // }
  }

  Future<void> _playSound(bool isOn) async {
    if (!_soundEnabled) return;
    try {
      if (isOn) {
        await SoundManager.playOnSound();
      } else {
        await SoundManager.playOffSound();
      }
    } catch (e) {
      // Ignore sound errors
    }
  }

  Future<void> _toggleTorch(bool state) async {
    if (!enableTorchHardware) return;
    try {
      if (state) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  void _stopFlashPattern() {
    _flashTimer?.cancel();
    _flashTimer = null;
    _isPatternRunning = false;
    // Don't automatically turn off torch here - let the calling method handle it
  }

  void _startStrobe() {
    bool strobeState = false;
    _isPatternRunning = true;

    _flashTimer = Timer.periodic(
      Duration(milliseconds: (500 / _strobeSpeed).round()),
      (timer) {
        if (!_isPatternRunning) {
          timer.cancel();
          return;
        }
        strobeState = !strobeState;
        _toggleTorch(strobeState);
      },
    );
  }

  void _toggleMode() async {
    switch (_currentMode) {
      case TorchMode.normal:
        final newState = !_isOn;
        setState(() => _isOn = newState);
        // Fire-and-forget sound to avoid blocking UI
        unawaited(_playSound(newState));
        await _toggleTorch(newState);

        if (newState) {
          _pulseController.repeat(reverse: true);
        } else {
          _pulseController.stop();
          _pulseController.reset();
        }
        break;

      case TorchMode.strobe:
        if (!_isOn) {
          setState(() => _isOn = true);
          unawaited(_playSound(true));
          _startStrobe();
          _pulseController.repeat(reverse: true);
        } else {
          setState(() => _isOn = false);
          unawaited(_playSound(false));
          _stopFlashPattern();
          await _toggleTorch(false); // Ensure torch is turned off
          _pulseController.stop();
          _pulseController.reset();
        }
        break;

      case TorchMode.screenLight:
        // On first turn-on, store and apply brightness
        if (!_isOn) {
          try {
            _systemBrightnessBeforeScreenLight ??=
                await ScreenBrightness().current;
          } catch (_) {}
          await _applyScreenBrightness(_screenBrightness);
        } else {
          // Turning OFF -> restore previous system brightness
          await _restoreSystemBrightness();
        }
        setState(() => _isOn = !_isOn);
        unawaited(_playSound(_isOn));
        if (_isOn) {
          _pulseController.repeat(reverse: true);
        } else {
          _pulseController.stop();
          _pulseController.reset();
        }
        break;
    }
  }

  Color _getScreenLightColor() {
    switch (_screenColor) {
      case ScreenLightColor.white:
        return Colors.white;
      case ScreenLightColor.red:
        return Colors.red;
      case ScreenLightColor.green:
        return Colors.green;
      case ScreenLightColor.blue:
        return Colors.blue;
      case ScreenLightColor.amber:
        return Colors.amber;
    }
  }

  Color _getButtonColor() {
    if (_currentMode == TorchMode.screenLight && _isOn) {
      return _getScreenLightColor();
    }
    return _isOn ? Colors.amber : const Color(0xFF2D2D2D);
  }

  Widget _buildColorPicker() {
    if (_currentMode != TorchMode.screenLight) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ScreenLightColor.values.map((color) {
          final isSelected = _screenColor == color;
          return GestureDetector(
            onTap: () async {
              HapticFeedback.selectionClick();
              await SoundManager.playClickSound();
              setState(() => _screenColor = color);
            },
            child: AnimatedScale(
              duration: const Duration(milliseconds: 150),
              scale: isSelected ? 1.1 : 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getScreenLightColorForPicker(color),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getScreenLightColorForPicker(ScreenLightColor color) {
    switch (color) {
      case ScreenLightColor.white:
        return Colors.white;
      case ScreenLightColor.red:
        return Colors.red;
      case ScreenLightColor.green:
        return Colors.green;
      case ScreenLightColor.blue:
        return Colors.blue;
      case ScreenLightColor.amber:
        return Colors.amber;
    }
  }

  Widget _buildSettingsPanel() {
    return AnimatedOpacity(
      opacity: _showSettings ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sound Effects',
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: _soundEnabled,
                  onChanged: (value) {
                    setState(() => _soundEnabled = value);
                    SoundManager.soundEnabled = value;
                  },
                  activeColor: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Brightness slider for screen light mode
            if (_currentMode == TorchMode.screenLight) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.brightness_low, color: Colors.white70, size: 20),
                  Expanded(
                    child: Slider(
                      value: _screenBrightness,
                      onChanged: (value) {
                        setState(() => _screenBrightness = value);
                        if (_isOn) {
                          _applyScreenBrightness(value);
                        }
                      },
                      onChangeEnd: (_) async {
                        HapticFeedback.selectionClick();
                        await SoundManager.playClickSound();
                      },
                      activeColor: _getScreenLightColor(),
                      inactiveColor: Colors.white24,
                      min: 0.05,
                      max: 1.0,
                      divisions: 19,
                      label: '${(_screenBrightness * 100).round()}%',
                    ),
                  ),
                  Icon(Icons.brightness_high, color: Colors.white70, size: 20),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Screen brightness: ',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${(_screenBrightness * 100).round()}%',
                    style: TextStyle(
                      color: _getScreenLightColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],

            // Speed control for Strobe mode
            if (_currentMode == TorchMode.strobe) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Strobe Speed',
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      value: _strobeSpeed,
                      onChanged: (value) {
                        setState(() => _strobeSpeed = value);
                        if (_isOn && _currentMode == TorchMode.strobe) {
                          // Restart strobe with new speed
                          _stopFlashPattern();
                          _startStrobe();
                        }
                      },
                      onChangeEnd: (_) async {
                        HapticFeedback.selectionClick();
                        await SoundManager.playClickSound();
                      },
                      activeColor: Colors.amber,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      label: '${_strobeSpeed.toStringAsFixed(1)}x',
                    ),
                  ),
                  Text(
                    '${_strobeSpeed.toStringAsFixed(1)}x',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableModeMenu() {
    // Animate menu expansion/collapse
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: _menuAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _menuAnimation.value,
              child: Transform.translate(
                offset: Offset(40 * (1 - _menuAnimation.value), 0),
                child: _showModeMenu
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildFloatingModeButton(
                            TorchMode.screenLight,
                            Icons.light_mode,
                            'Screen',
                          ),
                          const SizedBox(height: 8),
                          _buildFloatingModeButton(
                            TorchMode.strobe,
                            Icons.flash_on,
                            'Strobe',
                          ),
                          const SizedBox(height: 8),
                          _buildFloatingModeButton(
                            TorchMode.normal,
                            Icons.flashlight_on,
                            'Torch',
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _showModeMenu = !_showModeMenu;
              if (_showModeMenu) {
                _menuController.forward();
              } else {
                _menuController.reverse();
              }
            });
          },
          backgroundColor: Colors.amber,
          child: Icon(
            _showModeMenu ? Icons.close : Icons.menu,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = size.shortestSide * 0.5;

    return Scaffold(
      // Keep scaffold background black; we'll animate a full-screen colored
      // background container instead for smooth transitions.
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Animated background for screen light mode
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                color: (_currentMode == TorchMode.screenLight && _isOn)
                    ? _getScreenLightColor() // opaque, rely on system brightness
                    : Colors.black,
              ),
            ),
            // Main content - centered torch button
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Current mode indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getModeIcon(), size: 20, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          _getModeDisplayName(),
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Color picker for screen light mode
                  _buildColorPicker(),

                  const SizedBox(height: 32),

                  // Main torch button
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isOn ? _pulseAnimation.value : 1.0,
                        child: Semantics(
                          button: true,
                          label: _getModeLabel(),
                          child: SizedBox(
                            width: buttonSize.clamp(180, 320),
                            height: buttonSize.clamp(180, 320),
                            child: ElevatedButton(
                              onPressed: _isAvailable ? _toggleMode : null,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: _getButtonColor(),
                                foregroundColor: _isOn
                                    ? Colors.black
                                    : Colors.white,
                                elevation: _isOn ? 16 : 8,
                                shadowColor: _getButtonColor().withOpacity(0.6),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _getModeIcon(),
                                    size: 64,
                                    color: _isOn ? Colors.black : Colors.white,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _isOn ? 'ON' : 'OFF',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Status text
                  if (!_isAvailable)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        _error != null
                            ? 'Flashlight unavailable:\n$_error'
                            : 'Flashlight not available on this device.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),

            // Bottom-right expandable mode menu
            Positioned(
              bottom: 20,
              right: 20,
              child: _buildExpandableModeMenu(),
            ),

            // Settings button (top-right)
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => setState(() => _showSettings = !_showSettings),
                icon: Icon(
                  _showSettings ? Icons.close : Icons.settings,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
            ),

            // Settings panel
            if (_showSettings)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: _buildSettingsPanel(),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getModeIcon() {
    switch (_currentMode) {
      case TorchMode.normal:
        return Icons.flashlight_on;
      case TorchMode.strobe:
        return Icons.flash_on;
      case TorchMode.screenLight:
        return Icons.light_mode;
    }
  }

  String _getModeLabel() {
    final state = _isOn ? 'on' : 'off';
    switch (_currentMode) {
      case TorchMode.normal:
        return 'Turn flashlight $state';
      case TorchMode.strobe:
        return 'Turn strobe mode $state';
      case TorchMode.screenLight:
        return 'Turn screen light $state';
    }
  }

  String _getModeDisplayName() {
    switch (_currentMode) {
      case TorchMode.normal:
        return 'Torch';
      case TorchMode.strobe:
        return 'Strobe';
      case TorchMode.screenLight:
        return 'Screen Light';
    }
  }

  @override
  void dispose() {
    _stopFlashPattern();
    _pulseController.dispose();
    // Ensure we restore the system brightness if leaving screen light mode
    _restoreSystemBrightness();
    SoundManager.dispose();
    super.dispose();
  }
}
