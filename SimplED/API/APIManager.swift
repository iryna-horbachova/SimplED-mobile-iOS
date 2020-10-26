class APIManager {
  static let shared = APIManager()
  private let baseURL = "base_url"
  
  typealias coursesCompletionHandler = (Result<[Course], APIError>) -> Void
  typealias userCompletionHandler = (Result<[User], APIError>) -> Void
  
  private init() {}
  
  func login() {
    // if success, set as current user
  }
  
  func registerUser() {
    // if success, set as current user
  }
  
  func getCourses(
    page: Int,
    completion: @escaping coursesCompletionHandler
  ) {
    // TODO
  }
  
  func getCourses(
    category: String,
    page: Int,
    completion: @escaping coursesCompletionHandler
  ) {
    // TODO
  }
  
  func getAddedCourses(
    userId: Int,
    completion: @escaping coursesCompletionHandler
  ) {
    
  }
  
  func getEnrolledCourses(
    userId: Int,
    completion: @escaping coursesCompletionHandler
  ) {
    
  }
  
  func getUserInfo(
    id: Int,
    completion: @escaping userCompletionHandler
  ) {
    // TODO
  }
  
  func getAchievements(
    userId: Int
  ) {
    // TODO
  }
  
  func add(
    course: Course,
    userId: Int
  ) {
    
  }
}
