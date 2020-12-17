import UIKit

class ParticipantsTableViewController: UITableViewController {

  var creatorId: Int! {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  var participants = [User]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  let cellIdentifier = "participantTableViewCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(ParticipantTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    participants.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
      as! ParticipantTableViewCell
    cell.titleLabel.text = "\(participants[indexPath.row].firstName) \(participants[indexPath.row].lastName)"
    
    if participants[indexPath.row].id! == creatorId! {
      cell.statusLabel.text = "Creator"
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
}
