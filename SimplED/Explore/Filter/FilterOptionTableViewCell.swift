import UIKit

class FilterOptionTableViewCell: UITableViewCell {

  public var courseOption: CourseOption! {
    didSet {
      titleLabel.text = courseOption.title
    }
  }
  private let optionTag = 1
  
  let titleLabel: UILabel = {
    let label = UILabel.makeTitleLabel()
    label.text = NSLocalizedString(
      "COURSE_TITLE_LABEL",
      value: "Filter option title",
      comment: "Label showing the title of the course")
    return label
  }()
  
  private lazy var switchController: UISwitch = {
    let switchOnOff = UISwitch(frame: .zero)
    switchOnOff.isUserInteractionEnabled = true
    switchOnOff.setOn(false, animated: true)
    switchOnOff.tag = optionTag
    switchOnOff.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
    return switchOnOff
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .systemBackground
    selectionStyle = .none
    accessoryView = switchController
    addSubview(titleLabel)
    
    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: PADDING),
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: PADDING),
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -PADDING),
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PADDING),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func switchStateDidChange(_ sender: UISwitch){
    if (sender.isOn == true){
      print("UISwitch state is now ON")
    }
    else{
      print("UISwitch state is now Off")
    }
  }
}
