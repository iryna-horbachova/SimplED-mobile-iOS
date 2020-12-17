import UIKit

class CoursesViewController: UIViewController {
  
  let segmentedControl = makeSegmentedControl()
  let containerView = UIView()
  let coursesTVC = CourseTableViewController()
  
  override func viewDidLoad() {
    title = "Courses"
    view.backgroundColor = .systemBackground
    segmentedControl.addTarget(self, action: #selector(changeController(_:)), for: .valueChanged)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    // Adding view controllers to the container.
    addChild(coursesTVC)
    coursesTVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    coursesTVC.view.frame = containerView.bounds

    containerView.addSubview(coursesTVC.view)
    coursesTVC.didMove(toParent: self)
    
    coursesTVC.courses = APIManager.currentUser!.enrolledCourses!
    
    view.addSubview(segmentedControl)
    view.addSubview(containerView)
    
    NSLayoutConstraint.activate(
      [
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      ])
  }
  
  static func makeSegmentedControl() -> UISegmentedControl {
    let enrolledText = NSLocalizedString(
      "ENROLLED",
      value: "Enrolled",
      comment: "Enrolled segmented control")
    
    let createdText = NSLocalizedString(
      "ADDED",
      value: "Added",
      comment: "Created segmented control")
    
    let sControl = UISegmentedControl.makeSegmentedControl()
    
    sControl.insertSegment(withTitle: enrolledText, at: 0, animated: true)
    sControl.insertSegment(withTitle: createdText, at: 1, animated: true)
    sControl.selectedSegmentIndex = 0
    
    return sControl
  }
  
  @objc
  func changeController(_ sender: UISegmentedControl!) {
    if sender.selectedSegmentIndex == 0 {
      coursesTVC.courses = APIManager.currentUser!.enrolledCourses!
    }
    else {
      coursesTVC.courses = APIManager.currentUser!.addedCourses!
    }
  }
  
}
