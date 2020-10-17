import UIKit

class TabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let exploreVC = ExploreViewController()
    exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "explore"), selectedImage: UIImage(named: "explore"))

    let coursesVC = CoursesViewController()
    coursesVC.tabBarItem = UITabBarItem(title: "Courses", image: UIImage(named: "courses"), selectedImage: UIImage(named: "courses"))
    
    let profileVC = ProfileViewController()
    profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
    
    let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
    UINavigationBar.appearance().titleTextAttributes = attributes
    
    viewControllers = [exploreVC, coursesVC, profileVC].map { UINavigationController(rootViewController: $0) }
  }
}
