import UIKit

class SignUpViewController: BaseAuthViewController {
  
  let confirmPasswordTextField = UITextField.makeTextField()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    confirmPasswordTextField.delegate = self
    confirmPasswordTextField.isSecureTextEntry = true
    confirmPasswordTextField.returnKeyType = .done
    let confirmPasswordPlaceholderString = NSLocalizedString(
      "CONFIRM_PASSWORD_TEXTFIELD",
      value: "Confirm password",
      comment: "Confirm password textfield")
    confirmPasswordTextField.attributedPlaceholder = NSAttributedString(
      string: confirmPasswordPlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    textFieldStackView.addArrangedSubview(confirmPasswordTextField)
    continueButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
  }
  
  @objc func signUp(sender: UIButton!) {
    // - TODO: Add validation + alerts
    authenticateUser()
  }
  
  // MARK: - UITextFieldDelegate
  
  override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let _ = super.textFieldShouldReturn(textField)
    textField.resignFirstResponder()
    if textField == passwordTextField {
      confirmPasswordTextField.becomeFirstResponder()
    }
    return true
  }
  
}
