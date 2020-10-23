import UIKit

class ParticipantsTableViewController: UITableViewController {

  // TODO: Make resizable tableviewcells
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
    5
  }
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ParticipantTableViewCell
   
   return cell
   }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
}
