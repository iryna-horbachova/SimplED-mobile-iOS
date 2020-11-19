import UIKit

class SolutionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

  let textField = UITextView.makeTextView() 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Solution to the task"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addSolution))

    textField.text = "Solution"
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
  }
}
