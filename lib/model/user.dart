class User {
  final String imagePath;
  final String fullName;
  final String userName;
  final String email;
  final String password;

  const User({
    required this.imagePath,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
   
  });

  factory User.fromJson(Map<String, dynamic> usersjson) => User(
    imagePath: usersjson["AvatarUrl"],
    fullName: usersjson["Fullname"],
    userName: usersjson["Username"],
    email: usersjson["Email"],
    password: usersjson["Password"],
  );
  // Map<String, dynamic> toJson() => {
  //   'AvatarUrl': imagePath,
  //   'Fullname': fullName,
  //   'Username': userName,
  //   'Email': email,
  //   'Password': password,
  // };
}
