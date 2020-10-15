import UIKit

class TabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let exploreVC = ExploreViewController()
    exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "explore"), selectedImage: UIImage(named: "explore"))
    //xploreVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    let coursesVC = CoursesViewController()
    coursesVC.tabBarItem = UITabBarItem(title: "Courses", image: UIImage(named: "courses"), selectedImage: UIImage(named: "courses"))
    
    let profileVC = ProfileViewController()
    profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
    
    viewControllers = [exploreVC, coursesVC, profileVC]
  }
}
