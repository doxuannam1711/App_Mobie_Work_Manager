
class User {
  final int userID;

  // User(this.userID);
  const User({
    required this.userID,

  });

  User copy({
    int? userID,
  })=> User(
          userID: this.userID,
        );

  static User fromJson(Map<String, dynamic> json) => User(
        userID: json['userID'],
      );

  Map<String, dynamic> toJson() => {
        'UserID': userID,
      };
}
