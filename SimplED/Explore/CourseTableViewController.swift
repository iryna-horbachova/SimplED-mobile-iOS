import UIKit

class CourseTableViewController: UITableViewController {
  let cellIdentifier = "courseTableViewCell"
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5
  }
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTableViewCell
   
   return cell
   }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    200
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    let button = UIButton()
    button.backgroundColor = .mainTheme
   // button.frame.widt = view.frame.width
    button.setTitle("Filter >", for: .normal)
    button.titleLabel?.font =  .systemFont(ofSize: 20)
    button.layer.cornerRadius = CORNER_RADIUS
    button.translatesAutoresizingMaskIntoConstraints = false
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    NSLayoutConstraint.activate(
      [
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5),
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
      ])
    return view
  }
}
