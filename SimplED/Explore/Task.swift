import Foundation

struct Task: Codable {
  let id: Int?
  let title: String
  let description: String
  let deadline: String
  let course: Int?
}
