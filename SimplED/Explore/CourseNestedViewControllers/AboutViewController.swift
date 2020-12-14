import UIKit

class AboutViewController: UIViewController {
  
  var userIsEnrolled: Bool! {
    didSet {
      if !userIsEnrolled! {
        stackView.addArrangedSubview(enrollButton)
      } else {
        stackView.addArrangedSubview(joinVideoChatButton)
        stackView.addArrangedSubview(joinTextChatButton)
        stackView.addArrangedSubview(showTasksButton)
      }
    }
  }
  
  var creatorId: Int! {
    didSet {
      if creatorId == APIManager.currentUser!.id! {
        if isActive {
          stackView.addArrangedSubview(closeCourseButton)
        } else {
          stackView.addArrangedSubview(relaunchCourseButton)
        }
      }
    }
  }
  var isActive: Bool! = false
  
  let stackView = UIStackView.makeHorizontalStackView()
  let descriptionLabel = UILabel.makeSecondaryLabel()
  let joinVideoChatButton = UIButton.makeSecondaryButton(title: "Video chat")
  let joinTextChatButton = UIButton.makeSecondaryButton(title: "Chat")
  let showTasksButton = UIButton.makeSecondaryButton(title: "Tasks")
  let enrollButton = UIButton.makeSecondaryButton(title: "Enroll")
  let closeCourseButton = UIButton.makeSecondaryButton(title: "Close")
  let relaunchCourseButton = UIButton.makeSecondaryButton(title: "Relaunch")
  
  let tasksViewController = TasksTableViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    joinVideoChatButton.addTarget(self, action: #selector(pushVideoChatVC), for: .touchUpInside)
    joinTextChatButton.addTarget(self, action: #selector(pushChatVC), for: .touchUpInside)
    showTasksButton.addTarget(self, action: #selector(pushTasksVC), for: .touchUpInside)
    enrollButton.addTarget(self, action: #selector(enrollUser), for: .touchUpInside)
    
    view.addSubview(descriptionLabel)
    view.addSubview(stackView)

    NSLayoutConstraint.activate(
      [
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -PADDING),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        
        descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        descriptionLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -PADDING),
      ])
  }

  @objc private func pushVideoChatVC() {
   navigationController?.pushViewController(GroupVideoChatViewController(), animated: true)
  }
  
  @objc private func pushChatVC() {
   navigationController?.pushViewController(ChatRoomViewController(), animated: true)
  }
  
  @objc private func pushTasksVC() {
   navigationController?.pushViewController(tasksViewController, animated: true)
  }
  
  @objc private func enrollUser() {
    
    stackView.removeArrangedSubview(enrollButton)
    enrollButton.removeFromSuperview()
    userIsEnrolled = true
    present(UIAlertController.alertWithOKAction(
                  title: "Enroll successfully completed!",
                  message: "Knowledge is power. Don't stop studying."),
                 animated: true,
                 completion: nil)
    //view.willRemoveSubview(enrollButton)
  }
}
