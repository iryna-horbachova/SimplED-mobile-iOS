import UIKit

class ChatRoomViewController: UIViewController {
  
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
    
    messages.append(Message(senderName: "Ira", text: "Hello guys", type: .outgoing))
    messages.append(Message(senderName: "Ira", text: "Hellooooooooooooooooosddkjsnfjkldsflkbseakshedbbsellbh", type: .incoming))
    
    NotificationCenter.default.addObserver(self,
           selector: #selector(keyboardWillShow),
           name: UIResponder.keyboardWillChangeFrameNotification,
           object: nil)
    NotificationCenter.default.addObserver(self,
           selector: #selector(keyboardWillHide),
           name: UIResponder.keyboardWillHideNotification,
           object: nil)
    
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
    insertNewMessageCell(Message(senderName: "Someone", text: "Heeeey", type: .incoming))
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
    messages.append(message)
    let indexPath = IndexPath(row: messages.count - 1, section: 0)
    tableView.beginUpdates()
    tableView.insertRows(at: [indexPath], with: .bottom)
    tableView.endUpdates()
    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
  }
}

