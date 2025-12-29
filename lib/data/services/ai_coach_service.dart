import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Provider for the AI Coach service
final aiCoachServiceProvider = Provider<AiCoachService>((ref) {
  return AiCoachService();
});

/// Service for AI-powered fitness coaching using Gemini
class AiCoachService {
  GenerativeModel? _model;
  ChatSession? _chat;

  static const String _systemPrompt = '''
You are an expert AI fitness coach named "Coach" in the MyLift app. You are knowledgeable, motivating, and supportive.

Your role is to:
- Help users with workout planning and exercise selection
- Provide form tips and technique advice
- Offer motivation and encouragement
- Suggest exercise alternatives and modifications
- Help with recovery and injury prevention advice
- Answer questions about nutrition basics
- Create personalized workout suggestions

Guidelines:
- Keep responses concise and actionable (2-3 sentences when possible)
- Be encouraging but realistic
- Use fitness terminology appropriately
- If asked about medical issues, recommend consulting a healthcare professional
- Focus on safety first
- Be friendly and use a conversational tone

Remember: You're a fitness coach, not a doctor. For medical concerns, always recommend professional help.
''';

  /// Initialize the Gemini model with API key
  void initialize(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 500,
      ),
      systemInstruction: Content.system(_systemPrompt),
    );
    _startNewChat();
  }

  /// Start a new chat session
  void _startNewChat() {
    if (_model == null) return;
    _chat = _model!.startChat(history: []);
  }

  /// Check if the service is initialized
  bool get isInitialized => _model != null;

  /// Send a message to the AI coach and get a response
  Future<String> sendMessage(String message) async {
    if (_chat == null) {
      return _getFallbackResponse(message);
    }

    try {
      final response = await _chat!.sendMessage(Content.text(message));
      return response.text ?? _getFallbackResponse(message);
    } catch (e) {
      print('AI Coach Error: $e');
      return _getFallbackResponse(message);
    }
  }

  /// Generate a workout plan based on user preferences
  Future<String> generateWorkoutPlan({
    required String goal,
    required String experienceLevel,
    required List<String> availableEquipment,
    required int daysPerWeek,
    required int minutesPerSession,
  }) async {
    final prompt = '''
Generate a ${daysPerWeek}-day workout plan for someone with the following profile:
- Goal: $goal
- Experience Level: $experienceLevel
- Available Equipment: ${availableEquipment.join(', ')}
- Time per session: $minutesPerSession minutes

Provide a brief, structured plan with exercise names and sets/reps for each day.
''';

    return sendMessage(prompt);
  }

  /// Get exercise alternatives
  Future<String> getExerciseAlternatives({
    required String exercise,
    required List<String> availableEquipment,
    String? reason,
  }) async {
    final prompt = '''
Suggest 3 alternative exercises for "$exercise".
Available equipment: ${availableEquipment.join(', ')}
${reason != null ? 'Reason for swap: $reason' : ''}

For each alternative, briefly explain why it's a good substitute.
''';

    return sendMessage(prompt);
  }

  /// Get form tips for an exercise
  Future<String> getFormTips(String exercise) async {
    final prompt = '''
Provide 3-4 key form tips for performing "$exercise" safely and effectively.
Focus on the most common mistakes and how to avoid them.
''';

    return sendMessage(prompt);
  }

  /// Fallback responses when AI is unavailable
  String _getFallbackResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('missed') || lowerMessage.contains('skip')) {
      return "I noticed you missed a workout. Life happens - let's figure out how to get back on track. Would you like to reschedule or do a modified workout today?";
    }

    if (lowerMessage.contains('hurt') || lowerMessage.contains('pain') || lowerMessage.contains('injury')) {
      return "I'm sorry to hear that. Your health comes first. Please consult a healthcare professional for any injuries. In the meantime, we can focus on exercises that don't aggravate the issue.";
    }

    if (lowerMessage.contains('swap') || lowerMessage.contains('change') || lowerMessage.contains('replace')) {
      return "Sure, I can help you swap exercises. Tell me which exercise you'd like to change and what equipment you have available, and I'll suggest alternatives.";
    }

    if (lowerMessage.contains('tired') || lowerMessage.contains('exhausted')) {
      return "It sounds like you might need some recovery. Remember, rest is when your muscles actually grow! How about a lighter workout today or focus on mobility and stretching?";
    }

    if (lowerMessage.contains('warm') && lowerMessage.contains('up')) {
      return "A good warm-up should include 5-10 minutes of light cardio and dynamic stretches targeting the muscles you'll work. Want me to suggest a specific warm-up routine?";
    }

    if (lowerMessage.contains('thanks') || lowerMessage.contains('thank you')) {
      return "You're welcome! Keep pushing - you're making great progress. I'm here whenever you need guidance!";
    }

    if (lowerMessage.contains('workout') && lowerMessage.contains('suggest')) {
      return "I'd love to suggest a workout! Tell me: What's your goal (strength, muscle, endurance)? What equipment do you have? How much time do you have today?";
    }

    return "Great question! I'm here to help you reach your fitness goals. Feel free to ask me about exercises, form tips, workout planning, or anything fitness-related.";
  }

  /// Clear the chat history
  void clearHistory() {
    _startNewChat();
  }
}
