
import UIKit

class CourseViewController: UIViewController {
  var course: Course! {
    didSet {
     title = course.title
      if let image = course!.image {
        Utilities.loadImage(imageView: imageView, baseURLString: image)
      }
    }
  }
  
  let imageView = UIImageView.makeImageView(defaultImageName: "course-default")
  private let segmentedControl = makeSegmentedControl()
  private let containerView = UIView()
  
  private let aboutViewController = AboutViewController()
  private let tasksTableViewController = TasksTableViewController()
  private let chatViewController = ChatViewController()
  private let participantsTableViewController = ParticipantsTableViewController()
  
  private lazy var nestedVCs = [aboutViewController,
                                tasksTableViewController,
                                chatViewController,
                                participantsTableViewController]

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    
    if course!.creator == APIManager.currentUser?.id {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",style: .plain,
                                                          target: self, action: #selector(showEditCourseVC))
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Task",style: .plain,
                                                          target: self, action: #selector(showAddTaskVC))
    }
    tasksTableViewController.creatorId = course!.creator
    
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(containerView)
    view.addSubview(imageView)
    view.addSubview(segmentedControl)
    
    segmentedControl.addTarget(self, action: #selector(changeController(_:)), for: .valueChanged)
    
    
    NSLayoutConstraint.activate(
      [
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PADDING),
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        imageView.heightAnchor.constraint(equalToConstant: 250),

        segmentedControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: PADDING),
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        containerView.topAnchor.constraint(equalTo:
          segmentedControl.bottomAnchor, constant: 20),
        containerView.leadingAnchor.constraint(equalTo:
          view.leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo:
          view.trailingAnchor),
        containerView.bottomAnchor.constraint(equalTo:
          view.bottomAnchor),
      ])
    
    // Adding view controllers to the container.
    
    nestedVCs.forEach { vc in
      addChild(vc)
      vc.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      vc.view.frame = containerView.bounds
      containerView.addSubview(vc.view)
      vc.view.isHidden = true
      vc.didMove(toParent: self)
    }
    aboutViewController.descriptionLabel.text = course.description
    aboutViewController.view.isHidden = false
    
    APIManager.shared.getTasks(courseId: course.id!) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let tasks):
          DispatchQueue.main.async {
            self.tasksTableViewController.tasks = tasks
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
    
    APIManager.shared.getSolutions(courseId: course.id!) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let solutions):
          DispatchQueue.main.async {
            self.tasksTableViewController.solutions = solutions
          }
        case .failure(let error):
          DispatchQueue.main.async {
            self.present(UIAlertController.alertWithOKAction(
                          title: "Error occured with loading solutions!",
                          message: error.rawValue),
                         animated: true,
                         completion: nil)
          }
        }
    }
  }
  
  private static func makeSegmentedControl() -> UISegmentedControl {
    let aboutText = NSLocalizedString(
      "ABOUT",
      value: "About",
      comment: "About segmented control")
    
    let tasksText = NSLocalizedString(
      "TASKS",
      value: "Tasks",
      comment: "Tasks segmented control")
    
    let chatText = NSLocalizedString(
      "CHAT",
      value: "Chat",
      comment: "Chat segmented control")
    
    let participantsText = NSLocalizedString(
      "PARTICIPANTS",
      value: "Participants",
      comment: "Participants segmented control")

    let sControl = UISegmentedControl.makeSegmentedControl()
    
    sControl.insertSegment(withTitle: aboutText, at: 0, animated: true)
    sControl.insertSegment(withTitle: tasksText, at: 1, animated: true)
    sControl.insertSegment(withTitle: chatText, at: 2, animated: true)
    sControl.insertSegment(withTitle: participantsText, at: 3, animated: true)
  
    sControl.selectedSegmentIndex = 0
    return sControl
  }
  
  @objc private func changeController(_ sender: UISegmentedControl!) {
    nestedVCs.forEach { vc in
      vc.view.isHidden = true
    }
    nestedVCs[sender.selectedSegmentIndex].view.isHidden = false
  }
  
  @objc func showEditCourseVC() {
    let editCourseVC = CourseFormViewController()
    editCourseVC.controllerOption = .edit
    editCourseVC.course = course
    navigationController?.pushViewController(editCourseVC,
                                             animated: true)
  }
  
  @objc func showAddTaskVC() {
    let addTaskVC = AddTaskViewController()
    addTaskVC.courseId = course.id
    navigationController?.pushViewController(addTaskVC,
                                             animated: true)
  }
}
