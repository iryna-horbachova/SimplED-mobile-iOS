import UIKit

class CourseTableViewController: UITableViewController {
  public var courses: [Course]?
  public let filterTableViewController = FilterTableViewController()
  private let cellIdentifier = "courseTableViewCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    courses?.count ?? 0
  }
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTableViewCell
    cell.course = courses![indexPath.row]
   
   return cell
   }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let courseVC = CourseViewController()
    courseVC.course = courses![indexPath.row]
    present(UINavigationController(rootViewController: courseVC), animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    200
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UITableViewHeaderFooterView()
    let button = UIButton()
    button.backgroundColor = .greenTheme
    button.setTitle("Filter >", for: .normal)
    button.titleLabel?.font =  .systemFont(ofSize: 20)
    button.layer.cornerRadius = CORNER_RADIUS
    button.addTarget(self, action: #selector(showFilterTableViewController), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    header.translatesAutoresizingMaskIntoConstraints = false
    header.contentView.addSubview(button)
    NSLayoutConstraint.activate(
      [
        button.topAnchor.constraint(equalTo: header.contentView.topAnchor, constant: 5),
        button.leadingAnchor.constraint(equalTo: header.contentView.leadingAnchor, constant: 5),
        button.trailingAnchor.constraint(equalTo: header.contentView.trailingAnchor, constant: -5),
        button.bottomAnchor.constraint(equalTo: header.contentView.bottomAnchor, constant: -5),
      ])
    return header
  }
  
  @objc private func showFilterTableViewController(sender: UIButton!) {
    present(filterTableViewController, animated: true, completion: nil)
  }
  
}
