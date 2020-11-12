import Foundation

public struct Course: Codable {
  public let id: Int?
  public var title: String
  public var description: String
  public var image: String?
  public var category: String
  public var creator: Int?
  public var language: String
  public var participants: [Int]?
  public var startDate: String
}
