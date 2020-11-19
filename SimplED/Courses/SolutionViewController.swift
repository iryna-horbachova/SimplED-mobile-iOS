import UIKit

class SolutionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

  var solution: Solution?
  let textField = UITextView.makeTextView() 
  var taskId: Int?
  var courseId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Solution to the task"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addSolution))

    textField.text = solution?.text ?? "Solution"
    textField.delegate = self
    
    view.addSubview(textField)
    
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PADDING),
      textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
      textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
      textField.heightAnchor.constraint(equalToConstant: 200)
    ])
  }

  @objc func addSolution() {
    print("former solution")
    print(solution)
    let newSolution = Solution(id: nil, owner: APIManager.currentUser!, task: taskId!, text: textField.text!)
    
    APIManager.shared.add(solution: newSolution, courseId: courseId!) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(_):
        DispatchQueue.main.async {
          self.present(
            UIAlertController.alertWithOKAction(
              title: "Success!",
              message: "The solution was added successfully!"),
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
