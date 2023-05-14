class CardModel {
  final int listID;
  final int creatorID;
  final String cardName;
  final String label;
  final int comment;
  final String createdDate;
  final String dueDate; // Change type to String
  final String labelColor;

  CardModel({
    required this.listID,
    required this.creatorID,
    required this.cardName,
    required this.label,
    required this.comment,
    required this.createdDate,
    required String dueDateString, // Change type to String
    required this.labelColor,
  }) : dueDate = DateTime.parse(dueDateString).toIso8601String(); // Parse DateTime to String

  Map<String, dynamic> toJson() => {
        'listID': listID,
        'creatorID': creatorID,
        'cardName': cardName,
        'label': label,
        'comment': comment,
        'createdDate': createdDate,
        'dueDate': dueDate,
        'labelColor': labelColor,
      };
}