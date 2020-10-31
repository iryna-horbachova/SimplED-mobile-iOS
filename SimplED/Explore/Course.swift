import Foundation

public struct Course: Codable {
  public let id: Int?
  public let title: String
  public let description: String
  public let image: String?
  public let category: String
  public let creator: Int
  public let language: String
  public let participants: [Int]?
  public let startDate: String
}
