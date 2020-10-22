import UIKit

class CourseTableViewCell: UITableViewCell {

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
  
  let courseImageView: UIImageView = {
    return UIImageView.makeImageView(defaultImageName: "course-default")
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .systemBackground
    selectionStyle = .none
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.addArrangedSubview(courseImageView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(detailsLabel)
    stackView.spacing = 5
    stackView.distribution = .equalCentering
    addSubview(stackView)

    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: PADDING),
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -PADDING),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PADDING),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
