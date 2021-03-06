
import UIKit

class CourseViewController: UIViewController {
  var course: Course! {
    didSet {
     title = course.title
      if let image = course!.image {
        Utilities.loadImage(imageView: imageView, baseURLString: image)
      }
      getTasks()
      getParticipants()
      if participantsTableViewController.creatorId == nil {
        participantsTableViewController.creatorId = course!.creator
      }
    }
  }
  
  var participants = [User]() {
    didSet {
      participantsTableViewController.participants = participants
    }
  }
  
  private var userIsEnrolled: Bool?
  
  private let imageView = UIImageView.makeImageView(defaultImageName: "course-default")
  private let segmentedControl = makeSegmentedControl()
  private let containerView = UIView()
  
  private let aboutViewController = AboutViewController()
  private let tasksTableViewController = TasksTableViewController()
  private let chatViewController = ChatRoomViewController()
  private let participantsTableViewController = ParticipantsTableViewController()
  
  private lazy var nestedVCs = [aboutViewController,
                                participantsTableViewController]
  

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    userIsEnrolled = course!.participants!.contains(APIManager.currentUser!.id!) ||
      course!.creator == APIManager.currentUser?.id
    aboutViewController.userIsEnrolled = userIsEnrolled
    
    if course!.creator == APIManager.currentUser?.id {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",style: .plain,
                                                          target: self, action: #selector(showEditCourseVC))
    }
    aboutViewController.tasksViewController.creatorId = course!.creator
    aboutViewController.tasksViewController.courseId = course!.id
    aboutViewController.creatorId = course!.creator
    aboutViewController.course = course
    participantsTableViewController.creatorId = course!.creator
    aboutViewController.courseViewController = self
    
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
        
        containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
    aboutViewController.view.isHidden = false
  }
  
  // API
  
  private func getTasks() {
    APIManager.shared.getTasks(courseId: course.id!) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let tasks):
          DispatchQueue.main.sync {
            self.aboutViewController.tasksViewController.tasks = tasks
            
            for task in tasks {
              APIManager.shared.getSolutions(courseId: task.course!, taskId: task.id!) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let solutions):
                  DispatchQueue.main.async {
                    self.aboutViewController.tasksViewController.solutions += solutions
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
  
  private func getParticipants() {
    APIManager.shared.getCourseParticipants(id: course.id!) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let users):
        var gotParticipants = users
        APIManager.shared.getUser(id: self.course.creator!) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let user):
            gotParticipants.append(user)
            self.participants = gotParticipants
          case .failure(let error):
            print("unluck \(error.rawValue)")
          } 
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
  
  // UI
  
  private static func makeSegmentedControl() -> UISegmentedControl {
    let aboutText = NSLocalizedString(
      "ABOUT",
      value: "About",
      comment: "About segmented control")
    
    let participantsText = NSLocalizedString(
      "PARTICIPANTS",
      value: "Participants",
      comment: "Participants segmented control")

    let sControl = UISegmentedControl.makeSegmentedControl()
    
    sControl.insertSegment(withTitle: aboutText, at: 0, animated: true)
    sControl.insertSegment(withTitle: participantsText, at: 1, animated: true)
  
    sControl.selectedSegmentIndex = 0
    return sControl
  }
  
  @objc
  private func changeController(_ sender: UISegmentedControl!) {
    nestedVCs.forEach { vc in
      vc.view.isHidden = true
    }
    nestedVCs[sender.selectedSegmentIndex].view.isHidden = false
  }
  
  @objc
  private func showEditCourseVC() {
    let editCourseVC = CourseFormViewController()
    editCourseVC.controllerOption = .edit
    editCourseVC.course = course
    navigationController?.pushViewController(editCourseVC,
                                             animated: true)
  }
}
