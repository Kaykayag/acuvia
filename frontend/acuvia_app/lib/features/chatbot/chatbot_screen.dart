import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/models/chat.dart';
import 'package:go_router/go_router.dart'; 
// ─────────────────────────────────────────────────────────────────────────────
// Chat state
// ─────────────────────────────────────────────────────────────────────────────
class _ChatNotifier extends StateNotifier<List<ChatTurn>> {
  _ChatNotifier()
      : super([
          // Greeting shown on open
          ChatTurn(
            role: 'assistant',
            content:
                'Hello! I\'m the Acuvia Assistant powered by MedGemma. '
                'Describe your symptoms and I\'ll help you understand them.',
          ),
        ]);

  void addMessage(ChatTurn msg) => state = [...state, msg];

  void replaceLastAssistant(ChatTurn msg) {
    final updated = [...state];
    // find last assistant message (the typing indicator) and replace it
    for (int i = updated.length - 1; i >= 0; i--) {
      if (updated[i].role == 'assistant') {
        updated[i] = msg;
        break;
      }
    }
    state = updated;
  }
}

final _chatProvider =
  StateNotifierProvider<_ChatNotifier, List<ChatTurn>>(
  (_) => _ChatNotifier(),
);

// ─────────────────────────────────────────────────────────────────────────────
// Typing indicator bubble
// ─────────────────────────────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _dot(double delay) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        final t = ((_ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
        final offset = t < 0.5 ? t * 2 : (1 - t) * 2;
        return Transform.translate(
          offset: Offset(0, -4 * offset),
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF9E9E9E),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(0.0),
        const SizedBox(width: 4),
        _dot(0.15),
        const SizedBox(width: 4),
        _dot(0.3),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Message bubble
// ─────────────────────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatTurn message;
  final bool isTyping;

  const _MessageBubble({required this.message, this.isTyping = false});

  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          // User: teal-ish; Assistant: light grey (matching mockup)
          color: _isUser
              ? const Color(0xFFB2DFDB)   // soft teal like mockup
              : const Color(0xFFDDE8EA),  // light grey-blue like mockup
          borderRadius: BorderRadius.only(
            topLeft:     const Radius.circular(18),
            topRight:    const Radius.circular(18),
            bottomLeft:  Radius.circular(_isUser ? 18 : 4),
            bottomRight: Radius.circular(_isUser ? 4 : 18),
          ),
        ),
        child: isTyping
            ? const _TypingIndicator()
            : Text(
                message.content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF1A1A2E),
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ChatbotScreen
// ─────────────────────────────────────────────────────────────────────────────
class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;

    _input.clear();
    setState(() => _sending = true);

    final notifier = ref.read(_chatProvider.notifier);

    // Add user message
    notifier.addMessage(ChatTurn(role: 'user', content: text));
    _scrollToBottom();

    // Add typing indicator placeholder
    notifier.addMessage(
      ChatTurn(role: 'assistant', content: '__typing__'));
    _scrollToBottom();

    try {
      final repo = ref.read(chatRepositoryProvider);
      final reply = await repo.sendMessage(text);

        notifier.replaceLastAssistant(
          ChatTurn(role: 'assistant', content: reply));
    } catch (e) {
      notifier.replaceLastAssistant(ChatTurn(
        role: 'assistant',
        content: 'Sorry, I couldn\'t reach the assistant. Please try again.',
      ));
    }

    setState(() => _sending = false);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(_chatProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      // ── App bar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
            onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Acuvia Assistant',
          style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.45,
              child: Container(
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF26C6A6),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2)),
                ),
              ),
            ),
          ),
        ),
      ),

      // ── Messages list ──────────────────────────────────────────────────────
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];
                final isTyping = msg.content == '__typing__';
                return _MessageBubble(message: msg, isTyping: isTyping);
              },
            ),
          ),

          // ── Input bar ──────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDDE8EA),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1A1A2E)),
                      decoration: const InputDecoration(
                        hintText: 'Enter message',
                        hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Icon(
                      Icons.send_rounded,
                      color: _sending
                          ? const Color(0xFFBDBDBD)
                          : const Color(0xFF26C6A6),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}