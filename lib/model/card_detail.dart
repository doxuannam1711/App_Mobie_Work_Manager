class CardDetail {
  int cardID;
  String cardName;
  String description;
  String label;
  String listName;
  String dueDate; // Add this field

  CardDetail({
    required this.cardID,
    required this.cardName,
    required this.description,
    required this.label,
    required this.listName,
    required this.dueDate, // Initialize with a String value
  });

  factory CardDetail.fromJson(Map<String, dynamic> json) {
    return CardDetail(
      cardID: json['CardID'],
      cardName: json['CardName'],
      description: json['Description'] ?? '',
      label: json['LabelColor'],
      listName: json['ListName'],
      dueDate: json['DueDate'], // Assign value to dueDate field
    );
  }
}
