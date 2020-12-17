import UIKit

class CategoryCell: UITableViewCell {
  
  var courses: [Course]!
  let collectionView = UICollectionView.makeHorizontalCollectionView()
  let courseCellIdentifier = "courseCell"
  weak var parentViewController: ExploreViewController?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(CourseCollectionViewCell.self,
                            forCellWithReuseIdentifier: courseCellIdentifier)
    
    contentView.addSubview(collectionView)
    NSLayoutConstraint.activate(
      [
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}

extension CategoryCell : UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: courseCellIdentifier, for: indexPath) as! CourseCollectionViewCell
    cell.course = courses[indexPath.row]
    return cell
  }
  
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    courses.count
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    let courseVC = CourseViewController()
    courseVC.course = courses[indexPath.row]
    parentViewController?.present(UINavigationController(rootViewController: courseVC), animated: true)
    return true
  }
}

 extension CategoryCell : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: contentView.bounds.height)
  }
  
}
