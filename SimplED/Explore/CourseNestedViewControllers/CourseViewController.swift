
import UIKit

class CourseViewController: UIViewController {

  // TODO: If the user doesn't have access to the course, hide the tasks and chat
  // TODO: ADD MODEL AND REPLACE FAKE VALUES
  
  let titleLabel = TitleLabel(title: "Course Title", size: 25)
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
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(containerView)
    view.addSubview(titleLabel)
    view.addSubview(imageView)
    view.addSubview(segmentedControl)
    
    segmentedControl.addTarget(self, action: #selector(changeController(_:)), for: .valueChanged)
    
    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
  
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: PADDING),
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),

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
    aboutViewController.descriptionLabel.text = "Description of the course"
    aboutViewController.view.isHidden = false
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
    
    let sControl = UISegmentedControl(items: [aboutText,
                                              tasksText,
                                              chatText,
                                              participantsText])
    sControl.selectedSegmentIndex = 0
    sControl.selectedSegmentTintColor = .mainTheme
    sControl.layer.cornerRadius = CORNER_RADIUS
    
    sControl.setTitleTextAttributes(
      [NSAttributedString.Key.foregroundColor: UIColor.mainTheme],
      for: .normal
    )
    sControl.setTitleTextAttributes(
      [NSAttributedString.Key.foregroundColor: UIColor.white],
      for: .selected
    )
    
    sControl.translatesAutoresizingMaskIntoConstraints = false
  
    return sControl
  }
  
  @objc private func changeController(_ sender: UISegmentedControl!) {
    nestedVCs.forEach { vc in
      vc.view.isHidden = true
    }
    nestedVCs[sender.selectedSegmentIndex].view.isHidden = false
  }

}
