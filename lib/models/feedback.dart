class Feedback {
  final String sender;
  final String subject;
  final String messageBody;

  Feedback({required this.sender, required this.subject, required this.messageBody});

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'subject': subject,
      'messageBody': messageBody,
    };
  }
}
