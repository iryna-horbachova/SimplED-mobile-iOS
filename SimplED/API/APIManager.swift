import Foundation
import Keys
import Cloudinary

class APIManager {
  
  static var currentUser: User?
  static let shared = APIManager()
  private var token: Token?
  private let keys = SimplEDKeys()
  
  private let baseURL = "https://simpled-api.herokuapp.com/"
  public let baseImageURL = "https://res.cloudinary.com/hgrb5wnzc/"
  private let imageCloudName = "hgrb5wnzc"
  
  
  private var cloudinary: CLDCloudinary {
    
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://\(keys.cloudinaryAPIKey):\(keys.cloudinaryAPISecretKey)@\(imageCloudName)")

    return CLDCloudinary(configuration: config!)
  }
  
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
    let endpoint = baseURL + "users/\(user.id!)/"

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
    let endpoint = baseURL + "users/\(id)/"
    
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
    let endpoint = baseURL + "courses/\(id)/"
    
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
  
  func changeStatus(
    course: Course,
    completion: @escaping courseCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(course.id!)/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    let parameters: [String: Bool] = ["is_active": !course.isActive!]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

    } catch {
      print("invalid request body")
    }
    
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
  
  func enrollUserTo(
    course: Course,
    completion: @escaping courseCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(course.id!)/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    var participants = course.participants!
    participants.append(APIManager.currentUser!.id!)
    let parameters: [String: [Int]] = ["participants": participants]
    
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch {
      print("invalid request body")
    }
    
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
    taskId: Int,
    completion: @escaping solutionsCompletionHandler
  ) {
    print("getting solutions")
    let endpoint = baseURL + "courses/\(courseId)/tasks/\(taskId)/solutions/"
    
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
    taskId: Int,
    completion: @escaping solutionCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(courseId)/tasks/\(taskId)/solutions/"
    
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
  
  func update(
    solution: Solution,
    courseId: Int,
    taskId: Int,
    completion: @escaping solutionCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(courseId)/tasks/\(taskId)/solutions/\(solution.id!)/"
    
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
    let endpoint = baseURL + "users/\(id)/?nested=true"
    
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
    _ = params.setFolder(imageOption.rawValue)

    var url: String? = nil
    _ = cloudinary.createUploader().signedUpload(data: imageData, params: params, progress: nil) { result, error in
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
  
  func getCourseParticipants(
    id: Int,
    completion: @escaping usersCompletionHandler
  ) {
    let endpoint = baseURL + "courses/\(id)/participants/"
    
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
        let participants = try decoder.decode([User].self, from: data)
        completion(.success(participants))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  func getParticipantsArray(
    completion: @escaping participantsCompletionHandler
  ) {
    let endpoint = baseURL + "users/video-chat-users/"
    
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
        let participants = try decoder.decode([Participant].self, from: data)
        print(participants)
        completion(.success(participants))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  func getChatHistory(
    courseId: Int,
    completion: @escaping chatCompletionHandler
  ) {
    let endpoint = baseURL + "chats/\(courseId)/messages/"
    
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
        let messages = try decoder.decode([TextMessage].self, from: data)
        completion(.success(messages))
      } catch let error {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  // Email notification
  
  func notify(
    users: [String],
    subject: String,
    message: String,
    completion: @escaping (APIError?) -> ()
  ) {
    
    print("NOTIFY USER")
    let endpoint = baseURL + "users/notify/"

    guard let url = URL(string: endpoint) else {
      print("invalid url")
      completion(.invalidData)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token!.access!)", forHTTPHeaderField:"Authorization")
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    let parameters: [String: Any] = ["users": users, "subject": subject, "message": message]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

    } catch {
      print("invalid request body")
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      print("NOTIFY DATA")
      print(String(decoding: data!, as: UTF8.self))
      print(response)
      
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
      
      completion(nil)
      
    }
    task.resume()
  }
}

extension APIManager {
  typealias courseCompletionHandler = (Result<Course, APIError>) -> Void
  typealias categoryCoursesCompletionHandler = (Result<[String: [Course]], APIError>) -> Void
  typealias courseOptionsCompletionHandler = (Result<[CourseOption], APIError>) -> Void
  
  typealias chatCompletionHandler = (Result<[TextMessage], APIError>) -> Void
  
  typealias userCompletionHandler = (Result<User, APIError>) -> Void
  typealias usersCompletionHandler = (Result<[User], APIError>) -> Void
  typealias stringArrayCompletionHandler = (Result<[String], APIError>) -> Void
  typealias deleteCompletionHandler = (APIError?) -> Void
  
  typealias tasksCompletionHandler = (Result<[Task], APIError>) -> Void
  typealias taskCompletionHandler = (Result<Task, APIError>) -> Void
  
  typealias solutionsCompletionHandler = (Result<[Solution], APIError>) -> Void
  typealias solutionCompletionHandler = (Result<Solution, APIError>) -> Void
  typealias participantsCompletionHandler = (Result<[Participant], APIError>) -> Void
}
