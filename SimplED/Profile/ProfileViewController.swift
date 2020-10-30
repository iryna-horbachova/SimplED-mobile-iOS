import UIKit

class ProfileViewController: UIViewController {
  
  // TODO: REPLACE FAKE VALUES
  
  let avatarImageView = UIImageView.makeImageView(defaultImageName: "user-default")
  let nameLabel = UILabel.makeTitleLabel()
  let emailLabel = UILabel.makeSecondaryLabel()
  let bioLabel = UILabel.makeBodyLabel()
  let tableView = UITableView()
  
  let cellIdentifier = "userProfileOption"
  let options = ["Achievements", "Add course", "Log out"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Profile"
    view.backgroundColor = .systemBackground
 
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfile))
    
    view.addSubview(avatarImageView)
    view.addSubview(nameLabel)
    view.addSubview(emailLabel)
    view.addSubview(bioLabel)
    bioLabel.textAlignment = .center
    
    nameLabel.text = "Name Surname"
    emailLabel.text = "username@me.com"
    bioLabel.text = "20 y.o. student, study maths and machine learning"
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    tableView.register(ProfileOptionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PADDING),
      avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
      avatarImageView.widthAnchor.constraint(equalToConstant: 90),
      avatarImageView.heightAnchor.constraint(equalToConstant: 90),
      
      nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: PADDING),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      emailLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 15),
      emailLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: PADDING),
      emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
      emailLabel.heightAnchor.constraint(equalToConstant: 38),
      
      bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
      bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
      bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
      bioLabel.heightAnchor.constraint(equalToConstant: 100),
      
      tableView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  @objc func editProfile() {
    navigationController?.pushViewController(EditProfileViewController(), animated: true)
  }
}

extension ProfileViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ProfileOptionTableViewCell
   
    cell.titleLabel.text = options[indexPath.row]
    print(indexPath.row)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigationController?.pushViewController(AddCourseViewController(), animated: true)
  }

}

extension ProfileViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }

}
