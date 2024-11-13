import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smart_tasks/core/failure/failure.dart';
import 'package:smart_tasks/src/task/domain/repository/ai_description.repository.dart';

class AIDescriptionRepositoryImpl implements AIDescriptionRepository {
  final String _baseUrl;
  final String _model;
  final String _apiKey;
  final http.Client _client;

  AIDescriptionRepositoryImpl({
    String? baseUrl,
    String? model,
    String? apiKey,
    http.Client? client,
  })  : _baseUrl = baseUrl ?? const String.fromEnvironment('CEREBRAS_BASE_URL'),
        _model = model ?? const String.fromEnvironment('CEREBRAS_MODEL'),
        _apiKey = apiKey ?? const String.fromEnvironment('CEREBRAS_API_KEY'),
        _client = client ?? http.Client();

  @override
  Future<Either<Failure, String>> generateDescription(String taskTitle) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
          'Accept-Charset': 'utf-8',
        },
        body: utf8.encode(jsonEncode({
          'model': _model,
          'stream': false,
          'messages': [
            {
              'role': 'system',
              'content': _buildSystemPrompt(),
            },
            {
              'role': 'user',
              'content': _buildPrompt(taskTitle),
            }
          ],
          'temperature': 0,
          'max_completion_tokens': -1,
          'seed': 0,
          'top_p': 1,
          'response_format': {'type': 'json_object'}
        })),
      );

      if (response.statusCode != 200) {
        return left(
          Failure(
            code: response.statusCode,
            message:
                'Failed to generate description: ${utf8.decode(response.bodyBytes)}',
          ),
        );
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final description = data['choices'][0]['message']['content'];

      // Parse JSON response since we specified json_object format
      final jsonResponse = jsonDecode(description);
      final taskDescription = jsonResponse['description'] as String;
      final title = jsonResponse['title'] as String;

      return right("$title|$taskDescription");
    } catch (e) {
      return left(
        Failure(
          code: 500,
          message: 'Error generating description: ${e.toString()}',
        ),
      );
    }
  }

  String _buildSystemPrompt() {
    return '''
    You are an assistant that generates brief and clear task descriptions. You should:
    
    1. Keep descriptions concise but informative
    2. Interpret temporal references (tomorrow, next week, etc.)
    3. Respond in the same language as the task title
    4. Maintain a professional and direct tone
    5. Keep descriptions to 2-5 lines maximum
    ''';
  }

  String _buildPrompt(String taskTitle) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d');

    return '''
    Analyze this task title: "$taskTitle"

    Temporal context:
    Today is ${dateFormat.format(now)}
    
    Generate a brief description that:
    1. Identifies specific dates if temporal references are mentioned
    2. Explains the main objective concisely
    3. Maintains the same language as the task title
    4. Does not exceed 3-5 lines
    
    Response format JSON:
    { 
      "title: "Your brief title here",
      "description": "Your brief description here"
    }
    ''';
  }
}
