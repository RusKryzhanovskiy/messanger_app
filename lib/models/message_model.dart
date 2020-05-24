class MessageModel {
  final String id;
  final bool isRead;
  final String senderId;
  final String chatRoomId;
  final DateTime sendAt;
  final String text;

  const MessageModel({
    this.id,
    this.isRead,
    this.senderId,
    this.chatRoomId,
    this.sendAt,
    this.text,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'isRead': this.isRead,
      'senderId': this.senderId,
      'chatRoomId': this.chatRoomId,
      'sendAt': this.sendAt,
      'text': this.text,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      isRead: map['isRead'] as bool,
      senderId: map['senderId'] as String,
      chatRoomId: map['chatRoomId'] as String,
      sendAt: map['sendAt'] as DateTime,
      text: map['text'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isRead == other.isRead &&
          senderId == other.senderId &&
          chatRoomId == other.chatRoomId &&
          sendAt == other.sendAt &&
          text == other.text;

  @override
  int get hashCode =>
      id.hashCode ^
      isRead.hashCode ^
      senderId.hashCode ^
      chatRoomId.hashCode ^
      sendAt.hashCode ^
      text.hashCode;
}
