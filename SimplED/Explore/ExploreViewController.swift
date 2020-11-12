import UIKit

class ExploreViewController: UIViewController {

  var categoryCourses = [String: [Course]]() {
    didSet {
      categoryCourses.forEach {
        if $0.value.count != 0 {
          categories.append($0.key)
        }
      }
      tableView.reloadData()
    }
  }
  var categories = [String]()

  let tableView = UITableView()
  var searchController: UISearchController!
  let categoryCellIdentifier = "categoryCell"
  
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Explore"
    navigationController?.navigationBar.prefersLargeTitles = true
  
    getCourses()
    
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
    
    // TODO: SET A REAL USER ON LOAD
    /*APIManager.shared.getUser(id: 6) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let user):
        DispatchQueue.main.async {
          APIManager.currentUser = user
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
    }*/
  }
  
  private func getCourses() {
    APIManager.shared.getCourses { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let courses):
        DispatchQueue.main.async {
          self.categoryCourses = courses
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
    return categories[section].uppercased()
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
    let categoryTitle = categories[indexPath.section]
    let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier) as! CategoryCell
    cell.courses = categoryCourses[categoryTitle]
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
    // Update the filtered array based on the search text.
    var searchResults = [Course]()
    
    for (_, courses) in categoryCourses {
      searchResults.append(contentsOf: courses)
    }

    let filteredResults = searchResults.filter { $0.title.lowercased().contains(searchController.searchBar.text!.lowercased()) ||
      $0.description.lowercased().contains(searchController.searchBar.text!.lowercased())
    }

    // Apply the filtered results to the search results table.
    if let resultsController = searchController.searchResultsController as? CourseTableViewController {
        resultsController.courses = filteredResults
        resultsController.tableView.reloadData()

    }
  }
}

extension ExploreViewController: UISearchControllerDelegate, UISearchBarDelegate {
  
}
