import UIKit

class AboutViewController: UIViewController {

  let descriptionLabel = UILabel.makeSecondaryLabel() 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    view.addSubview(descriptionLabel)
    NSLayoutConstraint.activate(
      [
        descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -PADDING),
      ])
  }

}
