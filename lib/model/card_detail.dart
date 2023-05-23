class CardDetail {
  int cardID;
  String cardName;
  String description;
  String label;
  String listName;
  // thêm các thuộc tính khác nếu cần

  CardDetail(
      {required this.cardID,
      required this.cardName,
      required this.description,
      required this.label,
      required this.listName});

  factory CardDetail.fromJson(Map<String, dynamic> json) {
    return CardDetail(
      cardID: json['CardID'],
      cardName: json['CardName'],
      description: json['Description'],
      label: json['LabelColor'],
      listName: json['ListName'],
    );
  }
}
