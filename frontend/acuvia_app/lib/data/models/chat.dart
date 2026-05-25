class ChatTurn {
  final String role;
  final String content;

  const ChatTurn({
    required this.role,
    required this.content,
  });

  factory ChatTurn.fromJson(Map<String, dynamic> json) {
    return ChatTurn(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class ChatResponse {
  final String response;
  final List<ChatTurn> messages;

  const ChatResponse({
    required this.response,
    required this.messages,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatTurn.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}