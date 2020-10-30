public struct User: Decodable {
  public let id: Int
  public let firstName: String
  public let lastName: String
  public let email: String
  public let bio: String
  public let image: String
  public let points: Int
}
