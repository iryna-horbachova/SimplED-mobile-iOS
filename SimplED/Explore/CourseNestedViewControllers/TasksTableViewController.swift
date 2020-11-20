import UIKit

class TasksTableViewController: UITableViewController {
  
  var creatorId: Int?
  
  var tasks = [Task]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  var solutions = [Solution]() {
    didSet {
      tableView.reloadData()
    }
  }

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
    cell.parentViewController = self
    
    return cell
   }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.row]
    if creatorId == APIManager.currentUser!.id {
      let solutionVC = SolutionsTableViewController()
      solutionVC.solutions = solutions.filter{ $0.task == task.id }
      navigationController?.pushViewController(solutionVC, animated: true)
    } else {
      let solutionVC = SolutionViewController()
      solutionVC.solution = solutions.first(where: { $0.task == task.id  && $0.owner!.id == APIManager.currentUser!.id})
      solutionVC.taskId = task.id
      solutionVC.courseId = task.course
      navigationController?.pushViewController(solutionVC, animated: true)
    }
  }

}
