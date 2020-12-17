import UIKit

class CourseTableViewController: UITableViewController {
  public var courses: [Course]! {
    didSet {
      tableView.reloadData()
    }
  }
  
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let courseVC = CourseViewController()
    courseVC.course = courses![indexPath.row]
    present(UINavigationController(rootViewController: courseVC), animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    270
  }
}
