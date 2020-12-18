import UIKit

class AboutViewController: UIViewController {
  
  weak var courseViewController: CourseViewController?
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
  
  var creatorId: Int!
  
  var course: Course! {
    didSet {
      if creatorId == APIManager.currentUser!.id! {
        if course.isActive! {
          stackView.addArrangedSubview(closeCourseButton)
          relaunchCourseButton.removeFromSuperview()
        } else {
          stackView.addArrangedSubview(relaunchCourseButton)
          closeCourseButton.removeFromSuperview()
        }
      }
      descriptionLabel.text = course.description
    }
  }
  
  private let stackView = UIStackView.makeHorizontalStackView()
  private let descriptionLabel = UILabel.makeSecondaryLabel()
  private let joinVideoChatButton = UIButton.makeSecondaryButton(title: "Video chat")
  private let joinTextChatButton = UIButton.makeSecondaryButton(title: "Chat")
  private let showTasksButton = UIButton.makeSecondaryButton(title: "Tasks")
  private let enrollButton = UIButton.makeSecondaryButton(title: "Enroll")
  private let closeCourseButton = UIButton.makeSecondaryButton(title: "Archive")
  private let relaunchCourseButton = UIButton.makeSecondaryButton(title: "Relaunch")
  
  let tasksViewController = TasksTableViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    joinVideoChatButton.addTarget(self, action: #selector(pushVideoChatVC), for: .touchUpInside)
    joinTextChatButton.addTarget(self, action: #selector(pushChatVC), for: .touchUpInside)
    showTasksButton.addTarget(self, action: #selector(pushTasksVC), for: .touchUpInside)
    enrollButton.addTarget(self, action: #selector(enrollUser), for: .touchUpInside)
    closeCourseButton.addTarget(self, action: #selector(changeCourseStatus), for: .touchUpInside)
    relaunchCourseButton.addTarget(self, action: #selector(changeCourseStatus), for: .touchUpInside)
    
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

  @objc
  private func pushVideoChatVC() {
   navigationController?.pushViewController(GroupVideoChatViewController(), animated: true)
  }
  
  @objc
  private func pushChatVC() {
    let chatRoomVC = ChatRoomViewController()
    chatRoomVC.courseId = course.id!
   navigationController?.pushViewController(chatRoomVC, animated: true)
  }
  
  @objc
  private func pushTasksVC() {
   navigationController?.pushViewController(tasksViewController, animated: true)
  }
  
  @objc
  private func changeCourseStatus() {
    
    APIManager.shared.changeStatus(course: course) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let course):
          var message: String!
          
          DispatchQueue.main.sync {
            if course.isActive! {
              
              self.stackView.addArrangedSubview(self.closeCourseButton)
              message = "Course successfully relaunched!"
            } else {
              self.relaunchCourseButton.removeFromSuperview()
              self.stackView.addArrangedSubview(self.relaunchCourseButton)
              message = "Course successfully archived!"
            }
            self.course = course
            self.present(UIAlertController.alertWithOKAction(
                          title: "Success!",
                          message: message),
                         animated: true,
                         completion: nil)
            
          }
        case .failure(let error):
          DispatchQueue.main.async {
            self.present(UIAlertController.alertWithOKAction(
                          title: "Error occured with changing course status!",
                          message: error.rawValue),
                         animated: true,
                         completion: nil)
          }
        }
    }
  }
  
  @objc
  private func enrollUser() {
    
    APIManager.shared.enrollUserTo(course: course) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let course):
          print("success")
          print(course)
          DispatchQueue.main.sync {
            self.stackView.removeArrangedSubview(self.enrollButton)
            self.enrollButton.removeFromSuperview()
            self.userIsEnrolled = true
            self.present(UIAlertController.alertWithOKAction(
                          title: "Enroll successfully completed!",
                          message: "Knowledge is power. Don't stop studying."),
                         animated: true,
                         completion: nil)
            self.courseViewController?.participants.append(APIManager.currentUser!)
            
          }
        case .failure(let error):
          DispatchQueue.main.async {
            self.present(UIAlertController.alertWithOKAction(
                          title: "Error occured with loading tasks!",
                          message: error.rawValue),
                         animated: true,
                         completion: nil)
          }
        }
    }
  }
}
