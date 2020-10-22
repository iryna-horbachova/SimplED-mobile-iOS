
import UIKit

class TitleLabel: UILabel {

  init(title: String, size: CGFloat) {
    super.init(frame: .zero)
    font = .boldSystemFont(ofSize: size)
    textColor = .label
    text = title
    
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
