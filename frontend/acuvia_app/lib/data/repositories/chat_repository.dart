// lib/data/repositories/chat_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/http_client.dart';
import '../models/chat.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.read(dioProvider)),
);

class ChatRepository {
  ChatRepository(this._dio);
  final Dio _dio;

  // Keeps full history in memory for multi-turn context
  final List<ChatTurn> _history = [];

  Future<String> sendMessage(String userText) async {
    // Append user message to history
    _history.add(ChatTurn(role: 'user', content: userText));

    final res = await _dio.post(
      '/chat',
      data: {
        'messages': _history
            .map((m) => {'role': m.role, 'content': m.content})
            .toList(),
      },
    );

    final reply = res.data['reply'] as String;

    // Append assistant reply to history for next turn
    _history.add(ChatTurn(role: 'assistant', content: reply));

    return reply;
  }

  void clearHistory() => _history.clear();
}