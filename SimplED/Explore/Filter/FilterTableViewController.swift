import UIKit

class FilterTableViewController: UITableViewController {
  
  public var filterSections = [String]()
  public var categoryOptions = [String: [CourseOption]]()
  //private let filterSections = ["Category", "Languages", "Duration"]
  // private let filterOptions = ["Option 1", "Option 2", "Option 3"]
  private let reuseIdentifier = "filterOptionCell"
  
  // TODO: ADD MODEL
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(FilterOptionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return filterSections.count
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryOptions[filterSections[section]]?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return filterSections[section]
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.backgroundColor = .systemBackground
    header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    header.textLabel?.frame = header.frame
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    50
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FilterOptionTableViewCell
    let sectionTitle = filterSections[indexPath.section]
    cell.courseOption = categoryOptions[sectionTitle]![indexPath.row]
    return cell
  }
}
