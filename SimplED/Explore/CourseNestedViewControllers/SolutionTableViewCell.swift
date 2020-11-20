import UIKit

class SolutionTableViewCell: UITableViewCell {
  
  let titleLabel: UILabel = {
    let label = UILabel.makeTitleLabel()
    label.text = NSLocalizedString(
      "TASK_TITLE_LABEL",
      value: "Task title",
      comment: "Label showing the title of the task")
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
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .systemBackground
    selectionStyle = .none
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(detailsLabel)
    stackView.spacing = 5
    stackView.distribution = .equalCentering
    addSubview(stackView)

    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: PADDING),
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: PADDING),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PADDING),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -PADDING),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
