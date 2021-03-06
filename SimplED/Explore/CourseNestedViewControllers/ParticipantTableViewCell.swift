import UIKit

class ParticipantTableViewCell: UITableViewCell {
  
  let titleLabel: UILabel = {
    let label = UILabel.makeTitleLabel()
    return label
  }()
  
  let statusLabel: UILabel = {
    let label = UILabel()
    
    label.font = .systemFont(ofSize: 15)
    label.textColor = .label
    label.minimumScaleFactor = 0.9
    label.adjustsFontSizeToFitWidth   = true
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()
  
  let avatarImageView: UIImageView = {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.image = UIImage(named: "user-default")
    iv.layer.cornerRadius = 10
    return iv
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .systemBackground
    selectionStyle = .none
 
    addSubview(avatarImageView)
    addSubview(titleLabel)
    addSubview(statusLabel)

    NSLayoutConstraint.activate(
      [
        avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: PADDING),
        avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: PADDING),
        avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PADDING),
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),

        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: PADDING),
        titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: PADDING),
        //titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PADDING),
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -PADDING),
        
        statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
        statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: PADDING),
        statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PADDING),
        statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -PADDING),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
