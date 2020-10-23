import UIKit

class AboutViewController: UIViewController {

  let descriptionLabel = makeDescriptionLabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    view.addSubview(descriptionLabel)
    NSLayoutConstraint.activate(
      [
        descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PADDING),
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -PADDING),
      ])
  }
  
  static func makeDescriptionLabel() -> UILabel {
    let label = UILabel()
    label.text = "The label with the long description of the course from the course owner"
    label.textColor = .label
    label.numberOfLines = 0
    label.sizeToFit()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

}
