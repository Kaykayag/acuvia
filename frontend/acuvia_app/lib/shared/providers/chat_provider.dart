import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/chat.dart';
import '../../../data/repositories/chat_repository.dart';

final chatMessagesProvider =
    StateNotifierProvider<ChatController, List<ChatTurn>>(ChatController.new);

class ChatController extends StateNotifier<List<ChatTurn>> {
  ChatController(this._ref) : super(const []);
  final Ref _ref;

  bool _sending = false;
  bool get sending => _sending;

  Future<void> send(String message) async {
    if (message.trim().isEmpty) return;
    final userTurn = ChatTurn(role: 'user', content: message);
    state = [...state, userTurn];
    _sending = true;
    try {
      final resp = await _ref.read(chatRepositoryProvider).send(message);
      // Append assistant reply
      final asst = ChatTurn(role: 'assistant', content: resp.response);
      state = [...state, asst];
    } finally {
      _sending = false;
    }
  }

  void clear() => state = const [];
}
