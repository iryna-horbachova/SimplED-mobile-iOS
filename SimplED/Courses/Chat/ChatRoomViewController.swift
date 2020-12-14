import UIKit

class ChatRoomViewController: UIViewController {
  
  let messageInputView = MessageInputView()
  
  lazy var messageViewBottomConstraint =
    messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                             constant: 0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Chat"
    view.backgroundColor = .systemBackground
    
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
    
    messageInputView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(messageInputView)
    NSLayoutConstraint.activate([
      messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      messageInputView.heightAnchor.constraint(equalToConstant: 50),
    ])
    messageViewBottomConstraint.isActive = true
  }
  
  // Notification Center management
  @objc func keyboardWillShow(notification: NSNotification) {
    let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    messageViewBottomConstraint.constant = -keyboardSize!.height
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    messageViewBottomConstraint.constant = 0
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
}
