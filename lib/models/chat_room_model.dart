import 'package:messangerapp/models/message_model.dart';

class ChatRoomModel {
  final String id;
  final List<String> usersId;
  final MessageModel lastMessage;
  final List<MessageModel> messages;

  const ChatRoomModel({
    this.id,
    this.usersId,
    this.lastMessage,
    this.messages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'usersId': this.usersId,
      'lastMessage': this.lastMessage,
      'messages': this.messages,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'] as String,
      usersId:
          map['usersId'] == null ? null : map['usersId'].map<String>((e) => e),
      lastMessage: map['lastMessage'] == null
          ? null
          : MessageModel.fromMap(map['lastMessage']),
      messages: map['messages'] == null
          ? null
          : map['messages'].map<MessageModel>((e) => MessageModel.fromMap(e)),
    );
  }
}
