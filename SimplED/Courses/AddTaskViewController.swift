import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

  var courseId: Int?
  
  let titleTextField = UITextField.makeTextField()
  let descriptionTextView = UITextView.makeTextView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Add task"
    view.backgroundColor = .systemBackground
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addTask))
    
    titleTextField.delegate = self
    descriptionTextView.delegate = self
    
    titleTextField.text = "Title"
    descriptionTextView.text = "Description"
 
    let stackView = UIStackView.makeVerticalStackView()
    stackView.spacing = 1
    stackView.distribution = .equalSpacing
    
    stackView.addArrangedSubview(titleTextField)
    stackView.addArrangedSubview(descriptionTextView)
    view.addSubview(stackView)
    
    
    NSLayoutConstraint.activate(
      [
        descriptionTextView.heightAnchor.constraint(equalToConstant: 300),
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PADDING),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
      ])
  }
  
  @objc func addTask() {
    let task = Task(id: nil, title: titleTextField.text!, description:  descriptionTextView.text!, deadline: "2021-12-02T15:00:00Z", course: courseId)
    APIManager.shared.add(task: task, courseId: courseId!) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(_):
        DispatchQueue.main.async {
          self.present(
            UIAlertController.alertWithOKAction(
              title: "Success!",
              message: "The task was added successfully!"),
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
