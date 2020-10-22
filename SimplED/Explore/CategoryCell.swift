import UIKit

class CategoryCell: UITableViewCell {
  // TODO: ADD MODEL + DIDSET
  var collectionView: UICollectionView!
  let courseCellIdentifier = "courseCell"
  weak var parentViewController: ExploreViewController?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    
    collectionView = makeCollectionView()
    
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
  
  func makeCollectionView() -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
  
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.showsHorizontalScrollIndicator = true
    cv.isPagingEnabled = true
    cv.bounces = true
    cv.alwaysBounceHorizontal = true
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.backgroundColor = .systemBackground
    cv.dataSource = self
    cv.delegate = self
    cv.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: courseCellIdentifier)
    return cv
  }
}

extension CategoryCell : UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: courseCellIdentifier, for: indexPath) as! CourseCollectionViewCell
    return cell
  }
  
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    5
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: courseCellIdentifier, for: indexPath) as! CourseCollectionViewCell
    parentViewController?.present(CourseViewController(), animated: true)
    return true
  }
}

 extension CategoryCell : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: contentView.bounds.height)
  }
}
