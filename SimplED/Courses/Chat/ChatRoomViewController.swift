import UIKit
import Foundation

class ChatRoomViewController: UIViewController, ObservableObject {
  
  var courseId: Int!
  var socket: URLSessionWebSocketTask!
  private let session = URLSession(configuration: .default)
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  
  private var messages = [Message]()
  
  private let tableView = UITableView()
  private let messageInputView = MessageInputView()
  
  private lazy var messageViewBottomConstraint =
    messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                             constant: 0)
  private let messageCellIdentifier = "messageCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Chat"
    view.backgroundColor = .systemBackground
    
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    encoder.keyEncodingStrategy = .convertToSnakeCase
    connect()
    
    NotificationCenter.default.addObserver(self,
           selector: #selector(keyboardWillShow),
           name: UIResponder.keyboardWillChangeFrameNotification,
           object: nil)
    NotificationCenter.default.addObserver(self,
           selector: #selector(keyboardWillHide),
           name: UIResponder.keyboardWillHideNotification,
           object: nil)
    
    messageInputView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
    
    tableView.register(MessageCell.self, forCellReuseIdentifier: messageCellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    
    messageInputView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(messageInputView)
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      messageInputView.heightAnchor.constraint(equalToConstant: 60),
      
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    ])
    messageViewBottomConstraint.isActive = true
  }
  
  @objc
  private func sendButtonTapped() {
    print("sendButtonTapped")
    let text = messageInputView.textView.text!
    messageInputView.textView.text = ""
    let fullName = "\(APIManager.currentUser!.firstName) \(APIManager.currentUser!.lastName)"
    let message = TextMessage(senderId: APIManager.currentUser!.id!, fullName: fullName, text: text)
    send(message: message)
  }
  
  // Notification Center management
  
  @objc
  func keyboardWillShow(notification: NSNotification) {
    let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    messageViewBottomConstraint.constant = -keyboardSize!.height
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc
  func keyboardWillHide(notification: NSNotification) {
    messageViewBottomConstraint.constant = 0
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
}

extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier) as! MessageCell
    cell.selectionStyle = .none
    
    let message = messages[indexPath.row]
    cell.apply(message: message)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let height = MessageCell.height(for: messages[indexPath.row])
    return height
  }
  
  func insertNewMessageCell(_ message: Message) {
    DispatchQueue.main.async {
      self.messages.append(message)
      let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
      self.tableView.beginUpdates()
      self.tableView.insertRows(at: [indexPath], with: .bottom)
      self.tableView.endUpdates()
      self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
  }
}

// Web Sockets

extension ChatRoomViewController {
  
  func connect() {
    socket = session.webSocketTask(with: URL(string: "wss://simpled-api.herokuapp.com/chat/\(courseId!)/")!)
    listen()
    socket.resume()
  }
  
  func handle(_ data: Data) {
    do {
      let textMessage = try decoder.decode(TextMessage.self, from: data)
      var type: MessageType!
      
      if textMessage.senderId == APIManager.currentUser!.id! {
        type = .outgoing
      }
      else {
        type = .incoming
      }
      
      let message = Message(textMessage: textMessage, type: type)
      insertNewMessageCell(message)
    } catch {
      print(error)
    }
  }
  
  func send(message: TextMessage) {
    do {
      print(message)
      let data = try encoder.encode(message)
      let strData = String(decoding: data, as: UTF8.self)
      
      let task = URLSessionWebSocketTask.Message.string(strData)
      self.socket.send(task) { (err) in
        if err != nil {
          print(err.debugDescription)
        }
      }
    } catch {
      print(error)
    }
  }
  
  func listen() {
    self.socket.receive { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .failure(let error):
        print(error)
        return
      case .success(let message):
        switch message {
        case .data(let data):
          self.handle(data)
        case .string(let str):
          guard let data = str.data(using: .utf8) else { return }
          self.handle(data)
        @unknown default:
          break
        }
      }
      self.listen()
    }
  }
}

