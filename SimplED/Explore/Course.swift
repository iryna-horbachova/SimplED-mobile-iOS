import Foundation

struct Course: Decodable {
  let id: Int
  let title: String
  let details: String
  let category: String
  let teacher: String
  let language: String
  let startDate: Date
}
