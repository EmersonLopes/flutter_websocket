class ChatMessage {
  String? content;
  String? sender;

  ChatMessage({this.content, this.sender});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['sender'] = this.sender;
    return data;
  }
}
