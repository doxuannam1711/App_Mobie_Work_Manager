class BoardModel {
  final String boardName;
  final String labels;
  final String labelsColor;
  final String createdDate;
  final int UserID;

  BoardModel({
    required this.boardName,
    required this.labels,
    required this.labelsColor,
    DateTime? createdDate,
    required this.UserID,
  }) : createdDate = createdDate?.toIso8601String() ?? '';

  Map<String, dynamic> toJson() => {
        'BoardName': boardName,
        'Labels': labels,
        'LabelsColor': labelsColor,
        'CreatedDate': createdDate,
        'UserID': UserID,
      };
}
