class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  late DateTime createdon;
  int? unreadCount;
  bool? isStarred;

  MessageModel(
      {this.messageid,
      this.sender,
      this.text,
      this.seen = false,
      required this.createdon,
      this.unreadCount = 0,
      this.isStarred});
  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
    unreadCount = map["unreadCount"];
    isStarred = map["isStarred"] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "unreadCount": unreadCount,
      "isStarred":isStarred,
    };
  }

 
}