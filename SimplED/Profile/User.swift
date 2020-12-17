public struct User: Codable {
  public let id: Int?
  public var firstName: String
  public var lastName: String
  public var email: String
  public var bio: String?
  public var image: String?
  public var points: Int?
  public var password: String?
  public var confirmPassword: String?
  public var addedCourses: [Course]?
  public var enrolledCourses: [Course]?
}
