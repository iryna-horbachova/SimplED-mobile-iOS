struct User: Decodable {
  let id: Int
  let firstName: String
  let lastName: String
  let email: String
  let bio: String
  let image: String
  let points: Int
}
