class UserSchema {
  final int id;
  final String? username;
  final String displayName;
  final String? picture;
  final String? customStatus;
  final bool? online;

  UserSchema({
    required this.id,
    this.username,
    required this.displayName,
    this.picture,
    this.customStatus,
    this.online,
  });

  factory UserSchema.fromJson(Map<String, dynamic> json) {
    return UserSchema(
      id: json['id'],
      username: json['username'],
      displayName: json['display_name'],
      picture: json['picture'],
      customStatus: json['custom_status'],
      online: json['online'],
    );
  }
}

class UserEditRequest {
  final String? displayName;

  UserEditRequest({this.displayName});

  factory UserEditRequest.fromJson(Map<String, dynamic> json) {
    return UserEditRequest(displayName: json['display_name']);
  }
}

class UserEditResponse {
  final int id;
  final String? displayName;
  final String? picture;
  final String? customStatus;

  UserEditResponse({
    required this.id,
    this.displayName,
    this.picture,
    this.customStatus,
  });

  factory UserEditResponse.fromJson(Map<String, dynamic> json) {
    return UserEditResponse(
      id: json['id'],
      displayName: json['display_name'],
      picture: json['picture'],
      customStatus: json['custom_status'],
    );
  }
}

class UserOnline {
  final int id;
  final bool online;

  UserOnline({required this.id, required this.online});

  factory UserOnline.fromJson(Map<String, dynamic> json) {
    return UserOnline(id: json['id'], online: json['online']);
  }
}

class ServerSchema {
  final int id;
  final int ownerId;
  final String name;
  final String? picture;
  final String? banner;
  final String? roles;

  ServerSchema({
    required this.id,
    required this.ownerId,
    required this.name,
    this.picture,
    this.banner,
    this.roles,
  });

  factory ServerSchema.fromJson(Map<String, dynamic> json) {
    return ServerSchema(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      picture: json['picture'],
      banner: json['banner'],
      roles: json['roles'],
    );
  }
}

class ServerCreateRequest {
  final String name;

  ServerCreateRequest({required this.name});

  factory ServerCreateRequest.fromJson(Map<String, dynamic> json) {
    return ServerCreateRequest(name: json['name']);
  }
}

class ServerEditRequest {
  final String? name;

  ServerEditRequest({this.name});

  factory ServerEditRequest.fromJson(Map<String, dynamic> json) {
    return ServerEditRequest(name: json['name']);
  }
}

class ChannelSchema {
  final int id;
  final int serverId;
  final String name;

  ChannelSchema({required this.id, required this.serverId, required this.name});

  factory ChannelSchema.fromJson(Map<String, dynamic> json) {
    return ChannelSchema(
      id: json['id'],
      serverId: json['server_id'],
      name: json['name'],
    );
  }
}

class ChannelCreateRequest {
  final String name;

  ChannelCreateRequest({required this.name});

  factory ChannelCreateRequest.fromJson(Map<String, dynamic> json) {
    return ChannelCreateRequest(name: json['name']);
  }
}

class ChannelEditRequest {
  final String? name;

  ChannelEditRequest({this.name});

  factory ChannelEditRequest.fromJson(Map<String, dynamic> json) {
    return ChannelEditRequest(name: json['name']);
  }
}

class MessageCreateRequest {
  final String? name;

  MessageCreateRequest({this.name});

  factory MessageCreateRequest.fromJson(Map<String, dynamic> json) {
    return MessageCreateRequest(name: json['name']);
  }
}

class MessageEditRequest {
  final String name;

  MessageEditRequest({required this.name});

  factory MessageEditRequest.fromJson(Map<String, dynamic> json) {
    return MessageEditRequest(name: json['name']);
  }
}

class MessageEditResponse {
  final int id;
  final String message;
  final String? attachments;
  final String? edited;

  MessageEditResponse({
    required this.id,
    required this.message,
    this.attachments,
    this.edited,
  });

  factory MessageEditResponse.fromJson(Map<String, dynamic> json) {
    return MessageEditResponse(
      id: json['id'],
      message: json['message'],
      attachments: json['attachments'],
      edited: json['edited'],
    );
  }
}

class MessageResponse {
  final int id;
  final int senderId;
  final int channelId;
  final String message;
  final String? attachments;
  final String? edited;
  final String displayName;
  final String? picture;

  MessageResponse({
    required this.id,
    required this.senderId,
    required this.channelId,
    required this.message,
    this.attachments,
    this.edited,
    required this.displayName,
    this.picture,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      id: json['id'],
      senderId: json['sender_id'],
      channelId: json['channel_id'],
      message: json['message'],
      attachments: json['attachments'],
      edited: json['edited'],
      displayName: json['display_name'],
      picture: json['picture'],
    );
  }
}

class TypingSchema {
  final int userId;
  final String? displayName;

  TypingSchema({required this.userId, this.displayName});

  factory TypingSchema.fromJson(Map<String, dynamic> json) {
    return TypingSchema(
      userId: json['user_id'],
      displayName: json['display_name'],
    );
  }
}
