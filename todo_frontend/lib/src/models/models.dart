class Token {
  final String accessToken;
  final String tokenType;
  Token({required this.accessToken, this.tokenType = 'bearer'});

  factory Token.fromJson(Map<String, dynamic> json) =>
      Token(accessToken: json['access_token'], tokenType: json['token_type'] ?? 'bearer');

  Map<String, dynamic> toJson() => {'access_token': accessToken, 'token_type': tokenType};
}

class UserPublic {
  final String id;
  final String email;
  final String? createdAt;
  UserPublic({required this.id, required this.email, this.createdAt});

  factory UserPublic.fromJson(Map<String, dynamic> json) =>
      UserPublic(id: json['id'], email: json['email'], createdAt: json['created_at']);

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'created_at': createdAt};
}

class Todo {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final String userId;
  final String? createdAt;
  final String? updatedAt;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        completed: json['completed'] ?? false,
        userId: json['user_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'completed': completed,
        'user_id': userId,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    String? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
