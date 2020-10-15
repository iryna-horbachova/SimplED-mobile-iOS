import UIKit

class SignInViewController: BaseAuthViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    passwordTextField.returnKeyType = .done
    continueButton.addTarget(self, action: #selector(signIN), for: .touchUpInside)
  }
  
  @objc func signIN(sender: UIButton!) {
    // - TODO: Add validation + alerts
    authenticateUser()
  }
  
}
