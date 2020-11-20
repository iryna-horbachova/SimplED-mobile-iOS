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

    print(solution)
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
    if solution != nil {
      var updatedSolution = solution
      updatedSolution!.text = textField.text!
      APIManager.shared.update(solution: updatedSolution!, courseId: courseId!, taskId: taskId!) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(_):
          DispatchQueue.main.async {
            self.present(
              UIAlertController.alertWithOKAction(
                title: "Success!",
                message: "The solution was updated successfully!"),
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
    } else {
      let newSolution = Solution(id: nil, owner: nil, task: nil, text: textField.text!)
      APIManager.shared.add(solution: newSolution, courseId: courseId!, taskId: taskId!) { [weak self] result in
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
}
