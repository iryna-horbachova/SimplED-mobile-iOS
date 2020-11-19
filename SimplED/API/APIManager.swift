import Foundation
import Keys
import Cloudinary

class APIManager {
  
  static var currentUser: User?
  static let shared = APIManager()
  private var token: Token?
  private let keys = SimplEDKeys()
  
  private let baseURL = "http://simpled-api.herokuapp.com/"
  public let baseImageURL = "https://res.cloudinary.com/hgrb5wnzc/"
  private let imageCloudName = "hgrb5wnzc"
  
  
  private var cloudinary: CLDCloudinary {
    
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://\(keys.cloudinaryAPIKey):\(keys.cloudinaryAPISecretKey)@\(imageCloudName)")

    return CLDCloudinary(configuration: config!)
  }
  
  typealias courseCompletionHandler = (Result<Course, APIError>) -> Void
  typealias categoryCoursesCompletionHandler = (Result<[String: [Course]], APIError>) -> Void
  typealias courseOptionsCompletionHandler = (Result<[CourseOption], APIError>) -> Void
  typealias userCompletionHandler = (Result<User, APIError>) -> Void
  typealias stringArrayCompletionHandler = (Result<[String], APIError>) -> Void
  typealias deleteCompletionHandler = (APIError?) -> Void
  
  typealias tasksCompletionHandler = (Result<[Task], APIError>) -> Void
  typealias taskCompletionHandler = (Result<Task, APIError>) -> Void
  typealias solutionsCompletionHandler = (Result<[Solution], APIError>) -> Void
  typealias solutionCompletionHandler = (Result<Solution, APIError>) -> Void
  
  private init() {}
  
  func getToken(
    email: String,
    password: String,
    completion: @escaping (APIError?) -> ()
  ) {
    let endpoint = baseURL + "users/token/"
    let group = DispatchGroup()
    group.enter()
    
    guard let url = URL(string: endpoint) else {
      print("invalid url")
      completion(.invalidData)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    let parameters: [String: String] = ["email": email, "password": password]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

    } catch {
      print("invalid request body")
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      if let _ = error {
        print("got an error from the server")
        completion(.unableToComplete)
        return
      }

      guard let response = response as? HTTPURLResponse,
        (200 ... 299) ~= response.statusCode else {
        print("invalid response")
        completion(.invalidResponse)
        return
      }
      
      guard let data = data else {
        print("invalid data")
        completion(.invalidData)
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let receivedToken = try decoder.decode(Token.self, from: data)
        APIManager.shared.token = receivedToken
        UserDefaults.standard.set(receivedToken.access, forKey: "accessToken")
        UserDefaults.standard.set(receivedToken.refresh, forKey: "refreshToken")
        UserDefaults.standard.set(receivedToken.userId, forKey: "userId")
        group.leave()
        group.notify(queue: .main) {
          completion(nil)
        }
      } catch {
        print("invalid decoder")
        completion(.invalidData)
      }
    }
    task.resume()
  }
  
  func refreshToken(completion: @escaping (APIError?) -> ()) {
    let endpoint = baseURL + "users/refresh/"
    
    guard let url = URL(string: endpoint) else {
      print("invalid url")
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    let parameters: [String: String] = ["refresh": token!.refresh!]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

    } catch {
      print("invalid request body")
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in

      if let _ = error {
        print("got an error from the server")
        return
      }

      guard let response = response as? HTTPURLResponse,
        (200 ... 299) ~= response.statusCode else {
        print("invalid response")
        return
      }
      
      guard let data = data else {
        print("invalid data")
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let receivedToken = try decoder.decode(Token.self, from: data)
        APIManager.shared.token = receivedToken
        UserDefaults.standard.set(receivedToken.refresh, forKey: "refreshToken")
        completion(nil)
      } catch {
        print("invalid decoder")
      }
    }
    task.resume()
  }
  
  func refreshAuthenticatedUserOnAppStart(completion: @escaping (APIError?) -> ()) {
    let id = UserDefaults.standard.object(forKey: "userId") as! Int
    let refresh = UserDefaults.standard.object(forKey: "refreshToken") as! String
    let access = UserDefaults.standard.object(forKey: "accessToken") as! String
    APIManager.shared.token = Token(userId: id, refresh: refresh, access: access)
    refreshToken(completion: completion)
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
    print("update user")
    print(user)
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
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
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
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
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
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
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
      } catch _ {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  // MARK: - TASKS
  
  func getTasks(
    courseId: Int,
    completion: @escaping tasksCompletionHandler
  ) {
    print("getting tasks")
    let endpoint = baseURL + "courses/\(courseId)/tasks/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        let tasks = try decoder.decode([Task].self, from: data)
        print("tasks")
        print(tasks)
        completion(.success(tasks))
      } catch _ {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  func add(
    task: Task,
    courseId: Int,
    completion: @escaping taskCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(courseId)/tasks/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let httpBody = try encoder.encode(task)
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
        let task = try decoder.decode(Task.self, from: data)
        completion(.success(task))
      } catch {
        print("invalid decoder")
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  // MARK: - Solutions
  
  func getSolutions(
    courseId: Int,
    completion: @escaping solutionsCompletionHandler
  ) {
    print("getting solutions")
    let endpoint = baseURL + "courses/\(courseId)/solutions/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        let solutions = try decoder.decode([Solution].self, from: data)
        print("solutions")
        print(solutions)
        completion(.success(solutions))
      } catch _ {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  func add(
    solution: Solution,
    courseId: Int,
    completion: @escaping solutionCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(courseId)/solutions/"
    print("solution")
    print(solution)
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let httpBody = try encoder.encode(solution)
      request.httpBody = httpBody
    } catch {
      completion(.failure(.invalidData))
    }
  
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }

      print("solution response")
      print(response)
      
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
        let solution = try decoder.decode(Solution.self, from: data)
        completion(.success(solution))
      } catch {
        print("invalid decoder")
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
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
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
        var user = try decoder.decode(User.self, from: data)
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
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
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
        print("invalid decoder")
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
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
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
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
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
  
  func uploadImageToCloudinary(imageOption: ImageOption, imageData: Data, group: DispatchGroup, completionHandler: @escaping (String?) -> ()) {
    let params = CLDUploadRequestParams()
    params.setFolder(imageOption.rawValue)

    var url: String? = nil
    let request = cloudinary.createUploader().signedUpload(data: imageData, params: params, progress: nil) { result, error in
      group.enter()

      if error == nil {
        url = "v\(result!.version!)/\(result!.publicId!)"
      } else {
        url = APIManager.currentUser?.image
      }
      group.leave()
      group.notify(queue: .main) {
        completionHandler(url)
      }
    }
  }
}
