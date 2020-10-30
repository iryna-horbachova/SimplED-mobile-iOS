import UIKit

class AddCourseViewController: UIViewController, UITextFieldDelegate {
  
  let titleTextField = UITextField.makeTextField()
  let descriptionTextField = UITextField.makeTextField()
  let categoryTextField = UITextField.makeTextField()
  let languageTextField = UITextField.makeTextField()
  
  lazy var textfields = [ titleTextField,
                          descriptionTextField,
                          categoryTextField,
                          languageTextField ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Add course"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addCourse))
    
    let titlePlaceholderString = NSLocalizedString(
      "TITLE_TEXTFIELD",
      value: "Title",
      comment: "Title textfield")
    titleTextField.attributedPlaceholder = NSAttributedString(string: titlePlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let descriptionPlaceholderString = NSLocalizedString(
      "DESCRIPTION_TEXTFIELD",
      value: "Description",
      comment: "Description textfield")
    descriptionTextField.attributedPlaceholder = NSAttributedString(string: descriptionPlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let categoryPlaceholderString = NSLocalizedString(
      "CATEGORY_TEXTFIELD",
      value: "Category",
      comment: "Category textfield")
    categoryTextField.attributedPlaceholder = NSAttributedString(string: categoryPlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    let languagePlaceholderString = NSLocalizedString(
      "LANGUAGE_TEXTFIELD",
      value: "Language",
      comment: "Language textfield")
    languageTextField.attributedPlaceholder = NSAttributedString(string: languagePlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    
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
  
  @objc func addCourse() {
    present(
      UIAlertController.alertWithOKAction(title: "Success!",
                                          message: "The course was added successfully!"),
      animated: true,
      completion: nil
    )
  }
}
