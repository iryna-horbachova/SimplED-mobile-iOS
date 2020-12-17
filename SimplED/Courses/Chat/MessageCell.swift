import UIKit

class MessageCell: UITableViewCell {
  
  let messageLabel = UILabel.makeSecondaryLabel()
  let nameLabel = UILabel()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    nameLabel.textColor = .lightGray
    nameLabel.font = UIFont(name: "Helvetica", size: 10)

    clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
