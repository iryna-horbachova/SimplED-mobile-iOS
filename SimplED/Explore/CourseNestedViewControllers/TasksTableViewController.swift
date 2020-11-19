import UIKit

class TasksTableViewController: UITableViewController {
  
  var tasks = [Task]() {
    didSet {
      tableView.reloadData()
    }
  }
  // TODO: Make resizable tableviewcells
  let cellIdentifier = "taskTableViewCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tasks.count
  }
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let task = tasks[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskTableViewCell
    cell.titleLabel.text = task.title
    cell.detailsLabel.text = task.description
    
    return cell
   }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let id = indexPath.row
    navigationController?.pushViewController(SolutionViewController(), animated: true)
  }

}
