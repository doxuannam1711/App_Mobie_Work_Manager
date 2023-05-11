class ListModel {
  final int listID;
  final String listName;

  ListModel({
    required this.listID,
    required this.listName,
  });

  Map<String, dynamic> toJson() => {
        'ListID': listID,
        'ListName': listName,
      };
}