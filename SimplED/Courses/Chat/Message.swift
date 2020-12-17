struct Message {
  let senderName: String
  let text: String
  let type: MessageType
}

enum MessageType {
  case outgoing
  case incoming
}
