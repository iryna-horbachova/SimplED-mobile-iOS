public struct Message {
  public let textMessage: TextMessage
  public let type: MessageType
}

public struct TextMessage: Codable {
  let senderId: Int
  let fullName: String
  let text: String
}

public enum MessageType {
  case outgoing
  case incoming
}
