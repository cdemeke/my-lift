import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:async';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Voice input button with animated feedback
class VoiceInputButton extends StatefulWidget {
  final Function(String) onResult;
  final VoidCallback? onListeningStarted;
  final VoidCallback? onListeningStopped;

  const VoiceInputButton({
    super.key,
    required this.onResult,
    this.onListeningStarted,
    this.onListeningStopped,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _isAvailable = false;
  String _currentText = '';
  double _soundLevel = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initSpeech();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initSpeech() async {
    try {
      _isAvailable = await _speechToText.initialize(
        onStatus: _onStatus,
        onError: (error) {
          debugPrint('Speech error: ${error.errorMsg}');
          _stopListening();
        },
      );
      setState(() {});
    } catch (e) {
      debugPrint('Speech init error: $e');
      _isAvailable = false;
    }
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      if (_isListening && _currentText.isNotEmpty) {
        widget.onResult(_currentText);
      }
      _stopListening();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  Future<void> _startListening() async {
    if (!_isAvailable) {
      _showUnavailableDialog();
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _isListening = true;
      _currentText = '';
    });

    _pulseController.repeat(reverse: true);
    widget.onListeningStarted?.call();

    await _speechToText.listen(
      onResult: _onSpeechResult,
      onSoundLevelChange: (level) {
        setState(() => _soundLevel = level);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: 'en_US',
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _currentText = result.recognizedWords;
    });

    if (result.finalResult && _currentText.isNotEmpty) {
      widget.onResult(_currentText);
      _stopListening();
    }
  }

  void _stopListening() {
    _speechToText.stop();
    _pulseController.stop();
    _pulseController.reset();

    setState(() {
      _isListening = false;
      _soundLevel = 0;
    });

    widget.onListeningStopped?.call();
  }

  void _showUnavailableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Input Unavailable'),
        content: const Text(
          'Speech recognition is not available on this device. '
          'Please check your microphone permissions in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isListening ? AppColors.error : AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: _isListening
                ? [
                    BoxShadow(
                      color: AppColors.error.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Sound level indicator
              if (_isListening)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 48 + (_soundLevel * 2),
                  height: 48 + (_soundLevel * 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.error.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
              Icon(
                _isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen voice input overlay
class VoiceInputOverlay extends StatefulWidget {
  final Function(String) onResult;
  final VoidCallback onCancel;

  const VoiceInputOverlay({
    super.key,
    required this.onResult,
    required this.onCancel,
  });

  @override
  State<VoiceInputOverlay> createState() => _VoiceInputOverlayState();
}

class _VoiceInputOverlayState extends State<VoiceInputOverlay>
    with TickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _isAvailable = false;
  String _currentText = '';
  double _soundLevel = 0;
  String _statusMessage = 'Initializing...';

  late AnimationController _waveController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _initAndStart();
  }

  Future<void> _initAndStart() async {
    try {
      _isAvailable = await _speechToText.initialize(
        onStatus: _onStatus,
        onError: (error) {
          setState(() => _statusMessage = 'Error: ${error.errorMsg}');
          Future.delayed(const Duration(seconds: 2), widget.onCancel);
        },
      );

      if (_isAvailable) {
        _startListening();
      } else {
        setState(() => _statusMessage = 'Voice input not available');
        Future.delayed(const Duration(seconds: 2), widget.onCancel);
      }
    } catch (e) {
      setState(() => _statusMessage = 'Failed to initialize');
      Future.delayed(const Duration(seconds: 2), widget.onCancel);
    }
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      if (_currentText.isNotEmpty) {
        widget.onResult(_currentText);
      } else {
        widget.onCancel();
      }
    }
  }

  Future<void> _startListening() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isListening = true;
      _statusMessage = 'Listening...';
    });

    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _currentText = result.recognizedWords;
        });

        if (result.finalResult && _currentText.isNotEmpty) {
          widget.onResult(_currentText);
        }
      },
      onSoundLevelChange: (level) {
        setState(() => _soundLevel = level);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fadeController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: Material(
        color: Colors.black.withOpacity(0.9),
        child: SafeArea(
          child: Column(
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () {
                      _speechToText.stop();
                      widget.onCancel();
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Animated waves
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer waves
                    ...List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, child) {
                          final delay = index * 0.2;
                          final value = ((_waveController.value + delay) % 1.0);
                          return Container(
                            width: 100 + (value * 100) + (_soundLevel * 5),
                            height: 100 + (value * 100) + (_soundLevel * 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withOpacity(1 - value),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    // Center mic icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _isListening ? AppColors.primary : AppColors.grey600,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Status message
              Text(
                _statusMessage,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              // Recognized text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 100),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      _currentText.isEmpty ? 'Say something...' : _currentText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _currentText.isEmpty ? Colors.white38 : Colors.white,
                        fontSize: 20,
                        fontWeight: _currentText.isEmpty ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Send button
              if (_currentText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _speechToText.stop();
                        widget.onResult(_currentText);
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Send to Coach'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

/// Voice input hint chips for common questions
class VoiceInputHints extends StatelessWidget {
  final Function(String) onHintSelected;

  const VoiceInputHints({super.key, required this.onHintSelected});

  static const hints = [
    'What should I eat after workout?',
    'How do I improve my bench press?',
    'Am I overtraining?',
    'Create a leg day workout',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: AppColors.grey500),
              const SizedBox(width: 8),
              Text(
                'Try saying:',
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: hints.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(
                    hints[index],
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () => onHintSelected(hints[index]),
                  backgroundColor: AppColors.grey100,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
