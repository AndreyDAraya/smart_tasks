import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:smart_tasks/src/task/data/internal/repositories/ai_description.repository.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AIDescriptionRepositoryImpl repository;
  late MockHttpClient mockClient;

  const baseUrl = 'test-url';
  const model = 'test-model';
  const apiKey = 'test-key';

  setUp(() {
    mockClient = MockHttpClient();
    repository = AIDescriptionRepositoryImpl(
      baseUrl: baseUrl,
      model: model,
      apiKey: apiKey,
      client: mockClient,
    );
  });

  group('AIDescriptionRepositoryImpl', () {
    test('should return description when API call is successful', () async {
      // Arrange
      const taskTitle = 'Test Task';
      const innerJson =
          '{"title":"Test Title","description":"Test Description"}';
      final expectedResponse = {
        'choices': [
          {
            'message': {'content': innerJson}
          }
        ]
      };

      when(() => mockClient.post(
            Uri.parse('$baseUrl/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $apiKey',
              'Accept-Charset': 'utf-8',
            },
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(expectedResponse),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ));

      // Act
      final result = await repository.generateDescription(taskTitle);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return left'),
        (r) => expect(r, 'Test Title|Test Description'),
      );
    });

    test('should return failure when API call fails', () async {
      // Arrange
      const taskTitle = 'Test Task';
      const errorMessage = 'API Error';

      when(() => mockClient.post(
            Uri.parse('$baseUrl/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $apiKey',
              'Accept-Charset': 'utf-8',
            },
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(
            errorMessage,
            400,
          ));

      // Act
      final result = await repository.generateDescription(taskTitle);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) {
          expect(l.code, 400);
          expect(l.message, 'Failed to generate description: $errorMessage');
        },
        (r) => fail('Should not return right'),
      );
    });

    test('should return failure when outer JSON parsing fails', () async {
      // Arrange
      const taskTitle = 'Test Task';
      const invalidJson = '{invalid json}';

      when(() => mockClient.post(
            Uri.parse('$baseUrl/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $apiKey',
              'Accept-Charset': 'utf-8',
            },
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(
            invalidJson,
            200,
          ));

      // Act
      final result = await repository.generateDescription(taskTitle);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) {
          expect(l.code, 500);
          expect(l.message, contains('Error generating description'));
        },
        (r) => fail('Should not return right'),
      );
    });

    test('should return failure when inner JSON parsing fails', () async {
      // Arrange
      const taskTitle = 'Test Task';
      final expectedResponse = {
        'choices': [
          {
            'message': {'content': '{invalid inner json}'}
          }
        ]
      };

      when(() => mockClient.post(
            Uri.parse('$baseUrl/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $apiKey',
              'Accept-Charset': 'utf-8',
            },
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(expectedResponse),
            200,
          ));

      // Act
      final result = await repository.generateDescription(taskTitle);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) {
          expect(l.code, 500);
          expect(l.message, contains('Error generating description'));
        },
        (r) => fail('Should not return right'),
      );
    });
  });
}
