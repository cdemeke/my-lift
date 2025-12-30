import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../data/services/ai_coach_service.dart';
import '../../../data/services/settings_service.dart';
import '../widgets/voice_input_widget.dart';

/// AI Coach chat screen with Gemini integration.
class CoachChatScreen extends ConsumerStatefulWidget {
  const CoachChatScreen({super.key});

  @override
  ConsumerState<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends ConsumerState<CoachChatScreen>
    with TickerProviderStateMixin {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isInitialized = false;
  bool _showVoiceOverlay = false;
  String? _apiKeyError;

  final List<Map<String, dynamic>> _messages = [];

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _initializeAiCoach();
  }

  Future<void> _initializeAiCoach() async {
    final apiKey = await ref.read(settingsServiceProvider).getGeminiApiKey();
    final aiCoach = ref.read(aiCoachServiceProvider);

    if (apiKey != null && apiKey.isNotEmpty) {
      aiCoach.initialize(apiKey);
      setState(() {
        _isInitialized = true;
        _apiKeyError = null;
        _messages.add({
          'role': 'coach',
          'content': AppStrings.coachGreeting,
          'timestamp': DateTime.now(),
        });
      });
    } else {
      setState(() {
        _isInitialized = false;
        _apiKeyError = 'API key not configured';
        _messages.add({
          'role': 'coach',
          'content':
              "Hi! I'm your AI fitness coach. To unlock my full AI-powered capabilities, please add your Gemini API key in Settings. Until then, I can still help with basic fitness questions!",
          'timestamp': DateTime.now(),
        });
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'role': 'user',
        'content': text,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    final aiCoach = ref.read(aiCoachServiceProvider);
    final response = await aiCoach.sendMessage(text);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({
          'role': 'coach',
          'content': response,
          'timestamp': DateTime.now(),
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleVoiceInput(String text) {
    if (text.isEmpty) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _showVoiceOverlay = false;
      _messageController.text = text;
    });

    // Auto-send after voice input
    _sendMessage();
  }

  void _showVoiceInput() {
    HapticFeedback.mediumImpact();
    setState(() => _showVoiceOverlay = true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppStrings.coach,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 6),
                      if (_isInitialized)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'AI',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Text(
                    _isInitialized
                        ? 'Powered by Gemini AI'
                        : 'Basic mode - Add API key',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              final aiCoach = ref.read(aiCoachServiceProvider);
              aiCoach.clearHistory();
              setState(() {
                _messages.clear();
                _messages.add({
                  'role': 'coach',
                  'content': _isInitialized
                      ? "Chat cleared! What would you like to work on today?"
                      : "Chat cleared! Add your Gemini API key in settings for full AI features.",
                  'timestamp': DateTime.now(),
                });
              });
            },
            tooltip: 'Clear chat',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RoutePaths.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          // API Key banner
          if (!_isInitialized)
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingSm),
              margin: const EdgeInsets.all(AppDimensions.paddingSm),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Add Gemini API key in Settings for AI-powered responses',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.warning,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await context.push(RoutePaths.settings);
                      _initializeAiCoach();
                    },
                    child: const Text('Setup'),
                  ),
                ],
              ),
            ),

          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isTyping && index == _messages.length) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),

          // Quick prompts
          if (_messages.length <= 1)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
              ),
              child: Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: [
                  _buildQuickPrompt('How should I warm up?', Icons.whatshot),
                  _buildQuickPrompt('Suggest a workout', Icons.fitness_center),
                  _buildQuickPrompt('I need form tips', Icons.accessibility_new),
                  _buildQuickPrompt('Help me recover', Icons.healing),
                ],
              ),
            ),

          // Input field
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Voice input button
                  VoiceInputButton(
                    onResult: _handleVoiceInput,
                    onListeningStarted: () {
                      HapticFeedback.mediumImpact();
                    },
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type or tap mic to speak...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusFull,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingMd,
                          vertical: AppDimensions.paddingSm,
                        ),
                        suffixIcon: _messageController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _messageController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: FloatingActionButton(
                      onPressed: _sendMessage,
                      mini: true,
                      backgroundColor: _messageController.text.isNotEmpty
                          ? AppColors.primary
                          : AppColors.grey300,
                      child: Icon(
                        Icons.send,
                        color: _messageController.text.isNotEmpty
                            ? Colors.white
                            : AppColors.grey500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    // Voice input overlay
    if (_showVoiceOverlay)
      VoiceInputOverlay(
        onResult: _handleVoiceInput,
        onCancel: () => setState(() => _showVoiceOverlay = false),
      ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.secondary.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            'Your AI Fitness Coach',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            'Ask me anything about workouts,\nexercises, or nutrition!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isCoach = message['role'] == 'coach';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: Row(
        mainAxisAlignment:
            isCoach ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCoach)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
          if (isCoach) const SizedBox(width: AppDimensions.spacingSm),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: AppDimensions.chatBubbleMaxWidth,
              ),
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: isCoach ? AppColors.grey100 : AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isCoach ? 4 : 16),
                  bottomRight: Radius.circular(isCoach ? 16 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isCoach ? AppColors.grey300 : AppColors.primary)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message['content'] as String,
                style: TextStyle(
                  color: isCoach ? AppColors.grey900 : Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedDot(0),
                _buildAnimatedDot(1),
                _buildAnimatedDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = (_pulseController.value + delay) % 1.0;
        final size = 6 + (value * 4);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3 + (value * 0.5)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildQuickPrompt(String text, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: AppColors.primary),
      label: Text(text),
      onPressed: () {
        _messageController.text = text;
        _sendMessage();
      },
      backgroundColor: AppColors.primary.withOpacity(0.1),
      side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
    );
  }
}
