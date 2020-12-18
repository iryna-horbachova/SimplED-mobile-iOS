public struct Message {
  public let textMessage: TextMessage
  public let type: MessageType
}

public struct TextMessage: Codable {
  var senderId: Int?
  let sender: User?
  var fullName: String?
  let text: String
}

/* public struct ArchivedMessage: Codable {
  let sender: Int
  let fullName: String
  let text: String
} */

public enum MessageType {
  case outgoing
  case incoming
}
