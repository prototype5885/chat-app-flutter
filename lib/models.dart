class ServerModel {
  final String id;
  final String ownerID;
  final String name;
  final String picture;
  final String banner;

  const ServerModel({
    required this.id,
    required this.ownerID,
    required this.name,
    required this.picture,
    required this.banner,
  });

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      id: json['id'] ?? '',
      ownerID: json['ownerID'] ?? '',
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      banner: json['banner'] ?? '',
    );
  }
}

class ChannelModel {
  final String id;
  final String serverID;
  final String name;

  ChannelModel({required this.id, required this.serverID, required this.name});

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] ?? '',
      serverID: json['serverID'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class UserModel {
  final String id;
  final String displayName;
  final String picture;

  UserModel({this.id = '', this.displayName = '', this.picture = ''});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '0',
      displayName: json['displayName'] ?? 'Noname',
      picture: json['picture'] ?? '',
    );
  }
}

class MessageModel {
  final String id;
  final String channelID;
  final String userID;
  final String message;
  final List<String> attachments;
  final bool edited;
  final bool sameUser;

  final UserModel user;

  MessageModel({
    required this.id,
    required this.channelID,
    required this.userID,
    required this.message,
    this.attachments = const [],
    this.edited = false,
    required this.user,
    this.sameUser = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      channelID: json['channelID'] ?? '',
      userID: json['userID'] ?? '',
      message: json['message'] ?? '',
      attachments: json['attachments'] is String
          ? [json['attachments'] as String]
          : List<String>.from(json['attachments'] as List? ?? const []),
      edited: json['edited'] ?? false,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  MessageModel copyWith({
    String? id,
    String? channelID,
    String? userID,
    String? message,
    List<String>? attachments,
    bool? edited,
    bool? sameUser,
    UserModel? user,
  }) {
    return MessageModel(
      id: id ?? this.id,
      channelID: channelID ?? this.channelID,
      userID: userID ?? this.userID,
      message: message ?? this.message,
      attachments: attachments ?? this.attachments,
      edited: edited ?? this.edited,
      sameUser: sameUser ?? this.sameUser,
      user: user ?? this.user,
    );
  }
}
