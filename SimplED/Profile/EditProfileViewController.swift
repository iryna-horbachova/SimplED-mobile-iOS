import UIKit

class EditProfileViewController: UIViewController,
                                 UITextFieldDelegate,
                                 UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate{
  
  let firstNameTextField = UITextField.makeTextField()
  let emailTextField = UITextField.makeTextField()
  let lastNameTextField = UITextField.makeTextField()
  let bioTextField = UITextField.makeTextField()
  let imageView = UIImageView.makeImageView(defaultImageName: "user-default")
  let selectImageButton = UIButton.makeSecondaryButton(title: "Select image")
  
  lazy var textfields = [ emailTextField,
                          firstNameTextField,
                          lastNameTextField,
                          bioTextField ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
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
    
    selectImageButton.setTitle("Select image", for: .normal)
    selectImageButton.addTarget(self, action: #selector(displayImagePickerButtonTapped(_:)), for: .touchUpInside)

    
    firstNameTextField.text = APIManager.currentUser?.firstName
    lastNameTextField.text = APIManager.currentUser?.lastName
    emailTextField.text = APIManager.currentUser?.email
    bioTextField.text = APIManager.currentUser?.bio
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.spacing = 2
    stackView.distribution = .equalSpacing
    textfields.forEach {
      $0.delegate = self
      stackView.addArrangedSubview($0)
    }
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(selectImageButton)
    view.addSubview(stackView)

    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PADDING),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
      ])
  }
  
  @objc func updateProfile() {
    var user = APIManager.currentUser
    user?.firstName = firstNameTextField.text!
    user?.lastName = lastNameTextField.text!
    user?.email = emailTextField.text!
    user?.bio = bioTextField.text!
    
    APIManager.shared.update(user: user!) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let user):
        DispatchQueue.main.async {
          APIManager.currentUser = user
          self.present(
            UIAlertController.alertWithOKAction(
              title: "Success!",
              message: "Information updated successfully!"),
            animated: true,
            completion: nil
          )
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
  
  @objc func displayImagePickerButtonTapped(_ sender:UIButton!) {
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
    
    present(myPickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    imageView.backgroundColor = UIColor.clear
    imageView.contentMode = UIView.ContentMode.scaleAspectFit
    dismiss(animated: true, completion: nil)
  }

  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

}
