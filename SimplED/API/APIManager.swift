import Foundation

class APIManager {
  
  static var currentUser: User?
  static let shared = APIManager()
  
  private let baseURL = "http://simpled-api.herokuapp.com/"
  
  typealias courseCompletionHandler = (Result<Course, APIError>) -> Void
  typealias categoryCoursesCompletionHandler = (Result<[String: [Course]], APIError>) -> Void
  typealias courseOptionsCompletionHandler = (Result<[CourseOption], APIError>) -> Void
  typealias userCompletionHandler = (Result<User, APIError>) -> Void
  typealias stringArrayCompletionHandler = (Result<[String], APIError>) -> Void
  typealias deleteCompletionHandler = (APIError?) -> Void
  
  private init() {}
  
  func login() {
    // if success, set as current user
  }
  
  func register(
    user: User,
    completion: @escaping userCompletionHandler
  ) {
    let endpoint = baseURL + "users/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let httpBody = try encoder.encode(user)
      request.httpBody = httpBody
    } catch {
      completion(.failure(.invalidData))
    }
  
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }

      guard let response = response as? HTTPURLResponse,
        (200 ... 299) ~= response.statusCode else {
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
  
  func update(
    user: User,
    completion: @escaping userCompletionHandler
  ) {
    let endpoint = baseURL + "users/\(user.id!)"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let httpBody = try encoder.encode(user)
      request.httpBody = httpBody
    } catch {
      completion(.failure(.invalidData))
    }
  
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }

      guard let response = response as? HTTPURLResponse,
        (200 ... 299) ~= response.statusCode else {
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
  
  func deleteUser(
    id: Int,
    completion: @escaping deleteCompletionHandler
  ) {
    let endpoint = baseURL + "users/\(id)"
    
    guard let url = URL(string: endpoint) else {
      completion(.invalidData)
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let _ = error {
        completion(.unableToComplete)
        return
      }

      guard let response = response as? HTTPURLResponse,
        (200 ... 299) ~= response.statusCode else {
        completion(.invalidResponse)
        return
      }
      
      guard data != nil else {
        completion(.invalidData)
        return
      }
      completion(nil)
    }
    task.resume()
  }
  
  
  func getCourse(
    id: Int,
    completion: @escaping courseCompletionHandler
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
    completion: @escaping categoryCoursesCompletionHandler
  ) {
    let endpoint = baseURL + "courses/"
    
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
        let courses = try decoder.decode([String: [Course]].self, from: data)
        completion(.success(courses))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  func getCourses(
    category: String,
    page: Int,
    completion: @escaping courseCompletionHandler
  ) {
    // TODO
  }
  
  func getAddedCourses(
    userId: Int,
    completion: @escaping courseCompletionHandler
  ) {
    
  }
  
  func getEnrolledCourses(
    userId: Int,
    completion: @escaping courseCompletionHandler
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
    completion: @escaping courseCompletionHandler
  ) {
    let endpoint = baseURL + "courses/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let httpBody = try encoder.encode(course)
      request.httpBody = httpBody
    } catch {
      completion(.failure(.invalidData))
    }
  
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }

      guard let response = response as? HTTPURLResponse,
        (200 ... 299) ~= response.statusCode else {
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
  
  func update(
    course: Course,
    completion: @escaping courseCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(course.id!)"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let httpBody = try encoder.encode(course)
      request.httpBody = httpBody
    } catch {
      completion(.failure(.invalidData))
    }
  
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }

      guard let response = response as? HTTPURLResponse,
        (200 ... 299) ~= response.statusCode else {
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
  
  func deleteCourse(
    id: Int,
    completion: @escaping deleteCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(id)"
    
    guard let url = URL(string: endpoint) else {
      completion(.invalidData)
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let _ = error {
        completion(.unableToComplete)
        return
      }

      guard let response = response as? HTTPURLResponse,
        (200 ... 299) ~= response.statusCode else {
        completion(.invalidResponse)
        return
      }
      
      guard data != nil else {
        completion(.invalidData)
        return
      }
      completion(nil)
    }
    task.resume()
  }
}
