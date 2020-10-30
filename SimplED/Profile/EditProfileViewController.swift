import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
  
  let firstNameTextField = UITextField.makeTextField()
  let emailTextField = UITextField.makeTextField()
  let lastNameTextField = UITextField.makeTextField()
  let bioTextField = UITextField.makeTextField()
  
  lazy var textfields = [ emailTextField,
                          firstNameTextField,
                          lastNameTextField,
                          bioTextField ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Edit"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(updateProfile))
    
    emailTextField.keyboardType = .emailAddress
    let emailPlaceholderString = NSLocalizedString(
      "EMAIL_TEXTFIELD",
      value: "Email",
      comment: "Email textfield")
    emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let firstNamePlaceholderString = NSLocalizedString(
      "FIRST_NAME_TEXTFIELD",
      value: "First name",
      comment: "First name textfield")
    firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstNamePlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let lastNamePlaceholderString = NSLocalizedString(
      "LAST_NAME_TEXTFIELD",
      value: "Last name",
      comment: "Last name textfield")
    lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastNamePlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let bioPlaceholderString = NSLocalizedString(
      "BIO_TEXTFIELD",
      value: "Bio",
      comment: "Bio textfield")
    bioTextField.attributedPlaceholder = NSAttributedString(string: bioPlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.spacing = 5
    stackView.distribution = .equalSpacing
    textfields.forEach {
      $0.delegate = self
      stackView.addArrangedSubview($0)
    }
    view.addSubview(stackView)

    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PADDING),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
      ])
  }
  
  @objc func updateProfile() {
    present(
      UIAlertController.alertWithOKAction(title: "Success!",
                                          message: "Information updated successfully!"),
      animated: true,
      completion: nil
    )
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if let index = textfields.firstIndex(of: textField) {
      if index != textfields.count - 1 {
        textfields[index + 1].becomeFirstResponder()
      }
    }
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.placeholder = nil
  }
  
}
