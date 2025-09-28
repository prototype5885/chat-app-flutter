// class UserModel {
//   final String id;
//   final String displayName;
//   final String picture;
//
//   UserModel({
//     required this.id,
//     required this.displayName,
//     required this.picture,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] ?? '0',
//       displayName: json['displayName'] ?? 'Noname',
//       picture: json['picture'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'id': id, 'displayName': displayName, 'picture': picture};
//   }
//
//   @override
//   String toString() {
//     return 'UserModel(id: $id, displayName: $displayName, picture: $picture)';
//   }
// }

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
