// import 'Messagemodel.dart';

// class ChatRoomModel {
//   String chatroomid;
//   Map<String, dynamic>? participants;
//   String? lastMessage;
//   List<MessageModel>? messages;
//   Map<String, bool>? readStatus;

//   ChatRoomModel(
//       { required this.messages,required this.chatroomid,  required this.participants, required this.lastMessage});
//   ChatRoomModel.fromMap(Map<String, dynamic> map) {
//     chatroomid = map["chatroomid"];
//     participants = map["participants"];
//     lastMessage = map["lastmessage"];
//     messages = map["mesaages"];
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       "chatroomid": chatroomid,
//       "participants": participants,
//       "lastmessage": lastMessage,
//       "message": messages,
//     };
//   }
// }

import 'Messagemodel.dart';

class ChatRoomModel {
  late String chatroomid;
  late Map<String, dynamic>? participants;
  late String? lastMessage;
  late List<MessageModel>? messages; // Note: Changed "mesaages" to "messages"
  late Map<String, bool>? readStatus;
  bool? isPinned;

  DateTime? timestamp;

  ChatRoomModel({
    required this.chatroomid,
    required this.participants,
    required this.lastMessage,
    this.isPinned = false,
    this.messages,
    required List<String?> users,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    messages = (map["message"] as List<dynamic>?)?.map((item) {
      return MessageModel.fromMap(item as Map<String, dynamic>);
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "message": messages?.map((message) => message.toMap()).toList(),
    };
  }
  
}
