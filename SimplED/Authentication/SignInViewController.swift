import UIKit

class SignInViewController: BaseAuthViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    passwordTextField.returnKeyType = .done
    continueButton.addTarget(self, action: #selector(signIN), for: .touchUpInside)
  }
  
  @objc
  private func signIN(sender: UIButton!) {
    let email = emailTextField.text!
    let password = passwordTextField.text!
    APIManager.shared.getToken(email: email, password: password) { error in
      if let error = error {
        DispatchQueue.main.async {
          self.present(UIAlertController.alertWithOKAction(
                        title: "Error occured!",
                        message: error.rawValue),
                       animated: true,
                       completion: nil)
          }
      } else {
        DispatchQueue.main.async { [weak self] in
          self?.authenticateUser()
        }
      }

    }
  }
  
}
