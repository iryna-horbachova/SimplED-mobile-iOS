import UIKit

class ExploreViewController: UIViewController {

  var categories = [CourseOption]() {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    }
  }
  let tableView = UITableView()
  var searchController: UISearchController!
  let categoryCellIdentifier = "categoryCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Explore"
    navigationController?.navigationBar.prefersLargeTitles = true
  
    getCategories()
    
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        tableView.topAnchor.constraint(equalTo:
          view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo:
          view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo:
          view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo:
          view.bottomAnchor),
      ])
    
    tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    
    let resultsTableController = CourseTableViewController()
    
    searchController = UISearchController(searchResultsController: resultsTableController)
    searchController.delegate = self
    searchController.searchResultsUpdater = self
    searchController.searchBar.autocapitalizationType = .none
    searchController.searchBar.delegate = self
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true
 
    tableView.reloadData()
  }
  
  private func getCategories() {
    APIManager.shared.getCourseOptionsArray(endURL: "courses/categories/"){
      [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let categories):
        DispatchQueue.main.async {
          self.categories = categories
        }
  
      case .failure(let error):
        DispatchQueue.main.async {
          self.present(UIAlertController.alertWithOKAction(
                        title: "Error occured!",
                        message: error.rawValue),
                       animated: true,
                       completion: nil)
 
        }
      }
    }
  }
}

extension ExploreViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return categories[section].title
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.backgroundColor = .systemBackground
    header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    header.textLabel?.frame = header.frame
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier) as! CategoryCell
    cell.parentViewController = self
    return cell
  }

}

extension ExploreViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    140
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    50
  }
}

extension ExploreViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    print("updatesearchresults")
  }
}

extension ExploreViewController: UISearchControllerDelegate, UISearchBarDelegate {
  
}
