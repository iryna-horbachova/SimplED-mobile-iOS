import UIKit

class SolutionsTableViewController: UITableViewController {
  
  var solutions = [Solution]() {
    didSet {
      tableView.reloadData()
    }
  }

  let cellIdentifier = "solutionTableViewCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    tableView.register(SolutionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    solutions.count
  }
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let solution = solutions[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SolutionTableViewCell
    cell.titleLabel.text = "Solution by \(solution.owner!.firstName) \(solution.owner!.lastName)"
    cell.detailsLabel.text = solution.text
    
    return cell
   }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
}
