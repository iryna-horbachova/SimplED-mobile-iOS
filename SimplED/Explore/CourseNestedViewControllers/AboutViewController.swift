import UIKit

class AboutViewController: UIViewController {

  let descriptionLabel = UILabel.makeSecondaryLabel()
  let joinVideoChatButton = UIButton.makeSecondaryButton(title: "Join video chat")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    joinVideoChatButton.addTarget(self, action: #selector(pushVideoChatVC), for: .touchUpInside)
    
    view.addSubview(descriptionLabel)
    view.addSubview(joinVideoChatButton)
    NSLayoutConstraint.activate(
      [
        joinVideoChatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -PADDING),
        joinVideoChatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        joinVideoChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        
        descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        descriptionLabel.bottomAnchor.constraint(equalTo: joinVideoChatButton.topAnchor, constant: -PADDING),
      ])
  }

  @objc private func pushVideoChatVC() {
    present(GroupVideoChatViewController(), animated: true, completion: nil)
   // navigationController?.pushViewController(GroupVideoChatViewController(), animated: true)
  }
}
