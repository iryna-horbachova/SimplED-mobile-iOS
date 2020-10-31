import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
  var course: Course! {
    didSet {
      titleLabel.text = course.title
      detailsLabel.text = course.description
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel.makeTitleLabel()
    label.text = NSLocalizedString(
      "COURSE_TITLE_LABEL",
      value: "Course title",
      comment: "Label showing the title of the course")
  
    return label
  }()
  
  let detailsLabel: UILabel = {
    let label = UILabel()
    label.text = NSLocalizedString(
      "COURSE_DETAILS_LABEL",
      value: "Course details",
      comment: "Label showing the details of the course")
    
    label.font = .systemFont(ofSize: 15)
    label.textColor = .label
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.image = UIImage(named: "course-default")
    iv.layer.cornerRadius = 10
    return iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemBackground
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(detailsLabel)
    stackView.spacing = 5
    stackView.distribution = .equalCentering
    addSubview(stackView)

    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
