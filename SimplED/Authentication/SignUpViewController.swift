import UIKit

class SignUpViewController: BaseAuthViewController {
  
  private let confirmPasswordTextField = UITextField.makeTextField()
  private let firstNameTextField = UITextField.makeTextField()
  private let lastNameTextField = UITextField.makeTextField()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstNameTextField.delegate = self
    lastNameTextField.delegate = self
    let firstNamePlaceholderString = NSLocalizedString(
      "FIRST_NAME_TEXTFIELD",
      value: "First name",
      comment: "First name textfield")
    firstNameTextField.attributedPlaceholder = NSAttributedString(
      string: firstNamePlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let lastNamePlaceholderString = NSLocalizedString(
      "LAST_NAME_TEXTFIELD",
      value: "Last name",
      comment: "Last name textfield")
    lastNameTextField.attributedPlaceholder = NSAttributedString(
      string: lastNamePlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    
    confirmPasswordTextField.delegate = self
    confirmPasswordTextField.isSecureTextEntry = true
    confirmPasswordTextField.returnKeyType = .done
    confirmPasswordTextField.autocapitalizationType = .none
    let confirmPasswordPlaceholderString = NSLocalizedString(
      "CONFIRM_PASSWORD_TEXTFIELD",
      value: "Confirm password",
      comment: "Confirm password textfield")
    confirmPasswordTextField.attributedPlaceholder = NSAttributedString(
      string: confirmPasswordPlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let nameStackView = UIStackView.makeHorizontalStackView()
    nameStackView.addArrangedSubview(firstNameTextField)
    nameStackView.addArrangedSubview(lastNameTextField)
    nameStackView.distribution = .fillEqually
    nameStackView.spacing = 3
    textFieldStackView.insertArrangedSubview(nameStackView, at: 0)
    textFieldStackView.addArrangedSubview(confirmPasswordTextField)
    continueButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
  }
  
  @objc private func signUp(sender: UIButton!) {
    let email = emailTextField.text!
    let password = passwordTextField.text!
    let confirmPassword = confirmPasswordTextField.text!
    let firstName = firstNameTextField.text!
    let lastName = lastNameTextField.text!
    let user = User(id: nil, firstName: firstName, lastName: lastName, email: email, bio: nil, image: nil, points: nil, password: password, confirmPassword: confirmPassword)
    
    APIManager.shared.register(user: user){ [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let newUser):
          APIManager.shared.getToken(email: email, password: password) { error in
            if let error = error {
              self.present(UIAlertController.alertWithOKAction(
                            title: "Error occured!",
                            message: error.rawValue),
                           animated: true,
                           completion: nil)
            } else {
              APIManager.currentUser = newUser
              DispatchQueue.main.async { [weak self] in
                self?.authenticateUser()
              }
            }
          }
        
      case .failure(let error):
        DispatchQueue.main.async {
          self.present(UIAlertController.alertWithOKAction(
                        title: "Error occured!",
                        message: error.rawValue),
                       animated: true,
                       completion: nil)
        }
      }
    }
  }
  
  // MARK: - UITextFieldDelegate
  
  override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let _ = super.textFieldShouldReturn(textField)
    textField.resignFirstResponder()
    if textField == firstNameTextField {
      lastNameTextField.becomeFirstResponder()
    }
    else if textField == lastNameTextField {
      emailTextField.becomeFirstResponder()
    }
    else if textField == passwordTextField {
      confirmPasswordTextField.becomeFirstResponder()
    }
    return true
  }
  
}
