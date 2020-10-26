import Foundation

struct Task: Decodable {
  let id: Int
  let title: String
  let description: String
  let deadline: Date
}
