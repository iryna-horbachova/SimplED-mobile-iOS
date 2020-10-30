import Foundation

class APIManager {
  static let shared = APIManager()
  private let baseURL = "http://simpled-api.herokuapp.com/"
  
  typealias coursesCompletionHandler = (Result<Course, APIError>) -> Void
  typealias courseOptionsCompletionHandler = (Result<[CourseOption], APIError>) -> Void
  typealias userCompletionHandler = (Result<User, APIError>) -> Void
  typealias stringArrayCompletionHandler = (Result<[String], APIError>) -> Void
  
  private init() {}
  
  func login() {
    // if success, set as current user
  }
  
  func registerUser() {
    // if success, set as current user
  }
  
  func getCourse(
    id: Int,
    completion: @escaping coursesCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(id)"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }
        
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let course = try decoder.decode(Course.self, from: data)
        completion(.success(course))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  func getCourseOptionsArray(
    endURL: String,
    completion: @escaping courseOptionsCompletionHandler
  ) {
    let endpoint = baseURL + endURL
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }
        
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let courseOptions = try decoder.decode([CourseOption].self, from: data)
        completion(.success(courseOptions))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
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
  
  func getUser(
    id: Int,
    completion: @escaping userCompletionHandler
  ) {
    let endpoint = baseURL + "users/\(id)"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }
  
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(User.self, from: data)
        completion(.success(user))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
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
