import UIKit

public enum CourseVCOption {
  case edit
  case add
}

class CourseFormViewController: UIViewController,
                                UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {

  var controllerOption: CourseVCOption = .add
  var course: Course? {
    didSet {
      titleTextField.text = course!.title
      descriptionTextField.text = course!.description
      startDateTextField.text = course!.startDate
      if let image = course!.image {
        Utilities.loadImage(imageView: imageView, baseURLString: image)
      }
    }
  }
  
  let titleTextField = UITextField.makeTextField()
  let descriptionTextField = UITextField.makeTextField()
  let categoryTextField = UITextField.makeTextField()
  let languageTextField = UITextField.makeTextField()
  let startDateTextField = UITextField.makeTextField()
  
  let imageView = UIImageView.makeImageView(defaultImageName: "course-default")
  let selectImageButton = UIButton.makeSecondaryButton(title: "Select image")
  
  var categoryPicker: UIPickerView {
    let pickerView = UIPickerView()
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    pickerView.tag = 0
    pickerView.delegate = self
    pickerView.dataSource = self
    return pickerView
  }
  
  var languagePicker: UIPickerView {
    let pickerView = UIPickerView()
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    pickerView.tag = 1
    pickerView.delegate = self
    pickerView.dataSource = self
    return pickerView
  }
  
  var datePicker: UIDatePicker {
    let dp = UIDatePicker()
    dp.datePickerMode = UIDatePicker.Mode.date
    dp.addTarget(self, action: #selector(self.startDateChanged), for: .allEvents)
    return dp
  }
  
  var categories = [CourseOption]() {
    didSet {
      categoryPicker.reloadAllComponents()
    }
  }
  var languages = [CourseOption]() {
    didSet {
      languagePicker.reloadAllComponents()
    }
  }
  
  lazy var textfields = [ titleTextField,
                          descriptionTextField,
                          categoryTextField,
                          languageTextField,
                          startDateTextField ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    switch controllerOption {
    case .add:
      title = "Add course"
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addCourse))
    default:
      title = "Edit course"
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(editCourse))
    }
    
    // API
    getCourseOptions(endURL: "courses/categories/") { [weak self] options in
      DispatchQueue.main.async {
        self?.categories = options ?? []
        let category = self?.categories.first {
          $0.dbValue == self?.course?.category
        }
        self?.categoryTextField.text = category?.title ?? "Category"
      }
    }
    getCourseOptions(endURL: "courses/languages/") { [weak self] options in
      DispatchQueue.main.async {
        self?.languages = options ?? []
        let language = self?.languages.first {
          $0.dbValue == self?.course?.language
        }
        self?.languageTextField.text = language?.title ?? "Language"
      }
    }
    
    let titlePlaceholderString = NSLocalizedString(
      "TITLE_TEXTFIELD",
      value: "Title",
      comment: "Title textfield")
    titleTextField.attributedPlaceholder = NSAttributedString(
      string: titlePlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme]
    )
    
    let descriptionPlaceholderString = NSLocalizedString(
      "DESCRIPTION_TEXTFIELD",
      value: "Description",
      comment: "Description textfield")
    descriptionTextField.attributedPlaceholder = NSAttributedString(
      string: descriptionPlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme]
    )
    
    let categoryPlaceholderString = NSLocalizedString(
      "CATEGORY_TEXTFIELD",
      value: "Category",
      comment: "Category textfield")
    categoryTextField.attributedPlaceholder = NSAttributedString(
      string: categoryPlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme]
    )
    categoryTextField.inputView = categoryPicker
    
    let languagePlaceholderString = NSLocalizedString(
      "LANGUAGE_TEXTFIELD",
      value: "Language",
      comment: "Language textfield")
    languageTextField.attributedPlaceholder = NSAttributedString(
      string: languagePlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme]
    )
    languageTextField.inputView = languagePicker
    
    let startDatePlaceholderString = NSLocalizedString(
      "START_DATE_TEXTFIELD",
      value: "Start date",
      comment: "Start date textfield")
    startDateTextField.attributedPlaceholder = NSAttributedString(
      string: startDatePlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme]
    )
    startDateTextField.inputView = datePicker
    
    selectImageButton.setTitle("Select image", for: .normal)
    selectImageButton.addTarget(self, action: #selector(displayImagePickerButtonTapped(_:)), for: .touchUpInside)

    
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
    
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }
  
  @objc func addCourse() {
    let language = languages.first { $0.title == languageTextField.text }
    let category = categories.first { $0.title == categoryTextField.text }
    let course = Course(id: nil,
                        title: titleTextField.text!,
                        description: descriptionTextField.text!,
                        image: nil,
                        category: category!.dbValue,
                        creator: nil,
                        language: language!.dbValue,
                        participants: nil,
                        startDate: "2021-01-01")
    
    APIManager.shared.add(course: course) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let course):
        DispatchQueue.main.async {
          self.present(
            UIAlertController.alertWithOKAction(
              title: "Success!",
              message: "The course \(course.title) was added successfully!"),
            animated: true,
            completion: nil
          )
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          self.present(
            UIAlertController.alertWithOKAction(
              title: "Error occured!",
              message: error.rawValue),
            animated: true,
            completion: nil)
          
        }
      }
    }
  }
  
  @objc func editCourse() {
    let language = languages.first { $0.title == languageTextField.text }
    let category = categories.first { $0.title == categoryTextField.text }
    var updatedCourse = course
    updatedCourse?.title = titleTextField.text!
    updatedCourse?.description = descriptionTextField.text!
    updatedCourse?.language = language!.dbValue
    updatedCourse?.category = category!.dbValue
    
    let image = imageView.image
    let imageData = image?.pngData()
    let group = DispatchGroup()
    

    APIManager.shared.uploadImageToCloudinary(imageOption: .coursePic, imageData: imageData!, group: group) { url in
      updatedCourse?.image = url
      
      APIManager.shared.update(course: updatedCourse!) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let course):
          DispatchQueue.main.async {
            self.present(
              UIAlertController.alertWithOKAction(
                title: "Success!",
                message: "The course \(course.title) was updated successfully!"),
              animated: true,
              completion: nil
            )
          }
          
        case .failure(let error):
          DispatchQueue.main.async {
            self.present(
              UIAlertController.alertWithOKAction(
                title: "Error occured!",
                message: error.rawValue),
              animated: true,
              completion: nil)
            
          }
        }
      }
    }
  
  }
  
  private func getCourseOptions(endURL: String,
                                completion: @escaping ([CourseOption]?) -> Void) {
    APIManager.shared.getCourseOptionsArray(endURL: endURL){
      [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let options):
        completion(options)
        
      case .failure(let error):
        completion(nil)
        DispatchQueue.main.async {
          self.present(
            UIAlertController.alertWithOKAction(
              title: "Error occured!",
              message: error.rawValue),
            animated: true,
            completion: nil)
        }
      }
    }
  }
  
  @objc func startDateChanged() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.string(from: datePicker.date)
    startDateTextField.text = date
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
}

extension CourseFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch pickerView.tag {
    case 0:
      return categories.count
    case 1:
      return languages.count
    default:
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch pickerView.tag {
    case 0:
      return categories[row].title
    case 1:
      return languages[row].title
    default:
      return ""
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch pickerView.tag {
    case 0:
      categoryTextField.text = categories[row].title
    case 1:
      languageTextField.text = languages[row].title
    default:
     print("unknown pickerview")
    }
  }
}

extension CourseFormViewController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
  }

}
