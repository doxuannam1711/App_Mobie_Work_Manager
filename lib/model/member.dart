class MemberModel {
  final String fullname;
  final String Email;
  final String AvatarUrl;
  final int assignedTo;

  MemberModel({
    required this.fullname,
    required this.Email,
    required this.AvatarUrl,
    required this.assignedTo,
  });

  Map<String, dynamic> toJson() => {
        'fullname': fullname,
        'Email': Email,
        'AvatarUrl': AvatarUrl,
        'assignedTo': assignedTo,
      };
}
