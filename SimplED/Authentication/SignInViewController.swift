import UIKit

class SignInViewController: BaseAuthViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    passwordTextField.returnKeyType = .done
    continueButton.addTarget(self, action: #selector(signIN), for: .touchUpInside)
  }
  
  @objc private func signIN(sender: UIButton!) {
    var email = emailTextField.text!
    var password = passwordTextField.text!
    APIManager.shared.getToken(email: email, password: password) {
      DispatchQueue.main.async { [weak self] in
        self?.authenticateUser()
      }
    }
  }
  
}
