import UIKit

class MessageCell: UITableViewCell {
  
  let messageLabel = UILabel.makeSecondaryLabel()
  let nameLabel = UILabel()
  var messageType: MessageType = .incoming
  
  func apply(message: Message) {
    nameLabel.text = message.textMessage.fullName
    messageLabel.text = message.textMessage.text
    messageType = message.type
    setNeedsLayout()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    nameLabel.textColor = .lightGray
    nameLabel.font = UIFont(name: "Helvetica", size: 14)
    
    messageLabel.clipsToBounds = true
    messageLabel.textColor = .white
    messageLabel.numberOfLines = 0
    
    clipsToBounds = true
    
    addSubview(messageLabel)
    addSubview(nameLabel)

  }
  
  class func height(for message: Message) -> CGFloat {
    let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
    let nameHeight = message.type == .outgoing ? 0 : (height(forText: message.textMessage.fullName, fontSize: 10, maxSize: maxSize) + 4 )
    let messageHeight = height(forText: message.textMessage.text, fontSize: 17, maxSize: maxSize)
    
    return nameHeight + messageHeight + 32 + 16
  }
  
  private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
    let font = UIFont(name: "Helvetica", size: fontSize)!
    let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font: font,
                                                                  NSAttributedString.Key.foregroundColor: UIColor.white])
    let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height

    return textHeight
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MessageCell {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    messageLabel.font = UIFont(name: "Helvetica", size: 17)
    messageLabel.textColor = .white
    
    let size = messageLabel.sizeThatFits(CGSize(width: 2 * (bounds.size.width / 3), height: .greatestFiniteMagnitude))
    messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
    
    if messageType == .outgoing {
      nameLabel.isHidden = true
      
      messageLabel.center = CGPoint(x: bounds.size.width - messageLabel.bounds.size.width/2.0 - 16, y: bounds.size.height/2.0)
      messageLabel.backgroundColor = .mainTheme
    } else {
      nameLabel.isHidden = false
      nameLabel.sizeToFit()
      nameLabel.center = CGPoint(x: nameLabel.bounds.size.width / 2.0 + 16 + 4, y: nameLabel.bounds.size.height/2.0 + 4)
      
      messageLabel.center = CGPoint(x: messageLabel.bounds.size.width / 2.0 + 16, y: messageLabel.bounds.size.height/2.0 + nameLabel.bounds.size.height + 8)
      messageLabel.backgroundColor = .lightGray
    }
    
    messageLabel.layer.cornerRadius = min(messageLabel.bounds.size.height / 2.0, 20)
  }
  
}

