import UIKit

class BaseAuthViewController: UIViewController, UITextFieldDelegate {
  
  let emailTextField = UITextField.makeTextField()
  let passwordTextField = UITextField.makeTextField()

  let continueButton = UIButton.makeContinueButton()
  let forgotPasswordButton = makeForgotPasswordButton()
  
  let textFieldStackView = UIStackView.makeVerticalStackView()
  let buttonStackView = UIStackView.makeVerticalStackView()
  let scrollView = UIScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    // TODO: Add scrollview
    view.addSubview(self.scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    emailTextField.delegate = self
    emailTextField.keyboardType = .emailAddress
    let emailPlaceholderString = NSLocalizedString(
      "EMAIL_TEXTFIELD",
      value: "Email",
      comment: "Email textfield")
    emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    passwordTextField.delegate = self
    passwordTextField.isSecureTextEntry = true
    let passwordPlaceholderString = NSLocalizedString(
      "PASSWORD_TEXTFIELD",
      value: "Password",
      comment: "Password textfield")
    passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    textFieldStackView.spacing = 17
    
    textFieldStackView.addArrangedSubview(emailTextField)
    textFieldStackView.addArrangedSubview(passwordTextField)
    view.addSubview(textFieldStackView)
    
    buttonStackView.addArrangedSubview(continueButton)
    buttonStackView.addArrangedSubview(forgotPasswordButton)
    view.addSubview(buttonStackView)
  }
    
  override func viewWillLayoutSubviews() {
    NSLayoutConstraint.activate(
      [
        textFieldStackView.topAnchor.constraint(equalTo:
                                              view.safeAreaLayoutGuide.topAnchor),
        textFieldStackView.leadingAnchor.constraint(equalTo:
          view.leadingAnchor, constant: PADDING),
        textFieldStackView.trailingAnchor.constraint(equalTo:
          view.trailingAnchor, constant: -PADDING),
      ])
    
    NSLayoutConstraint.activate(
      [
        buttonStackView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 20),
        buttonStackView.leadingAnchor.constraint(equalTo:
          view.leadingAnchor, constant: PADDING),
        buttonStackView.trailingAnchor.constraint(equalTo:
          view.trailingAnchor, constant: -PADDING),
      ])
  }
  
  static func makeForgotPasswordButton() -> UIButton {
    let button = UIButton()
    let text = NSLocalizedString(
      "FORGOT_PASSWORD",
      value: "Forgot password?",
      comment: "Forgot password button")
    button.setTitle(text, for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
  
  func authenticateUser() {
    // - TODO: add authentication with server
    view.window?.rootViewController = TabBarController()
    view.window?.makeKeyAndVisible()
  }
  
  // - MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    }
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.placeholder = nil
  }
}


