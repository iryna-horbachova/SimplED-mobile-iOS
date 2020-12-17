import UIKit

class AuthenticationViewController: UIViewController {
  
  let logoLabel = makeLogoLabel()
  let segmentedControl = makeSegmentedControl()
  
  var containerView = UIView()
  let signInViewController = SignInViewController()
  let signUpViewController = SignUpViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    segmentedControl.addTarget(self, action: #selector(changeController(_:)), for: .valueChanged)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(logoLabel)
    view.addSubview(segmentedControl)
    view.addSubview(containerView)
    
    NSLayoutConstraint.activate(
      [
        logoLabel.topAnchor.constraint(equalTo:
          view.safeAreaLayoutGuide.topAnchor, constant: 100),
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        segmentedControl.topAnchor.constraint(equalTo:
          logoLabel.bottomAnchor, constant: 20),
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
    addChild(signInViewController)
    addChild(signUpViewController)
    
    signInViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    signInViewController.view.frame = containerView.bounds
    
    signUpViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    signUpViewController.view.frame = containerView.bounds
    
    containerView.addSubview(signInViewController.view)
    containerView.addSubview(signUpViewController.view)
    signInViewController.view.isHidden = true
      
    // Notify the child view controller that the move is complete.
    signInViewController.didMove(toParent: self)
    signUpViewController.didMove(toParent: self)
  }
  
  // MARK: - User interface
  
  static func makeLogoLabel() -> UILabel {
    let label = UILabel()
    label.text = NSLocalizedString(
      "SIMPLED_LABEL",
      value: "SimplED",
      comment: "Main title showing App Logo")
    
    label.font = .boldSystemFont(ofSize: 50)
    label.textColor = .mainTheme
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }
  
  static func makeSegmentedControl() -> UISegmentedControl {
    let signUpText = NSLocalizedString(
      "SIGN_UP",
      value: "Sign Up",
      comment: "Sign up segmented control")
    
    let signInText = NSLocalizedString(
      "SIGN_IN",
      value: "Sign In",
      comment: "Sign in segmented control")
    
    let sControl = UISegmentedControl.makeSegmentedControl()
    
    sControl.insertSegment(withTitle: signInText, at: 1, animated: true)
    sControl.insertSegment(withTitle: signUpText, at: 0, animated: true)
    
    sControl.selectedSegmentIndex = 0
  
    return sControl
  }
  
  @objc
  func changeController(_ sender: UISegmentedControl!) {
    signInViewController.view.isHidden = !signInViewController.view.isHidden
    signUpViewController.view.isHidden = !signUpViewController.view.isHidden
  }
  
}

