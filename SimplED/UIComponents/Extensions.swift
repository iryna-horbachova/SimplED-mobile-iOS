import UIKit

extension UIColor {
  convenience init(r: Int, g: Int, b: Int) {
    self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
  }
  
  static var mainTheme: UIColor {
    return UIColor(r: 1, g: 186, b: 239)
  }
  
  static var greenTheme: UIColor {
    return UIColor(r: 125, g: 207, b: 182)
  }
}

extension UITextField {
  static func makeTextField() -> UITextField {
    let textField =  UITextField()
    textField.font = .systemFont(ofSize: 22)
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.textColor = .mainTheme
    textField.backgroundColor = .systemBackground
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = UIColor.mainTheme.cgColor
    
    textField.autocorrectionType = .no
    textField.keyboardType = .default
    textField.returnKeyType = .next
    textField.clearButtonMode = UITextField.ViewMode.whileEditing
    textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    
    textField.layer.cornerRadius = CORNER_RADIUS
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }
}

extension UITextView {
  static func makeTextView() -> UITextView {
    let textView = UITextView()

    textView.font = .systemFont(ofSize: 22)
 
    textView.textColor = .mainTheme
    textView.backgroundColor = .systemBackground
    textView.layer.borderWidth = 1.0
    textView.layer.borderColor = UIColor.mainTheme.cgColor
    
    textView.autocorrectionType = .no
    textView.keyboardType = .default
    textView.returnKeyType = .next
    
    textView.layer.cornerRadius = CORNER_RADIUS
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }
}

extension UIButton {
  static func makeContinueButton() -> UIButton {
    let button = UIButton()
    button.backgroundColor = .mainTheme
    button.setTitle("Continue", for: .normal)
    button.titleLabel?.font =  .boldSystemFont(ofSize: 25)
    button.layer.cornerRadius = CORNER_RADIUS
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
  
  static func makeSecondaryButton(title: String) -> UIButton {
    let button = UIButton()
    button.tintColor = .mainTheme
    button.titleLabel?.font =  .preferredFont(forTextStyle: .title2)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.mainTheme, for: .normal)
    button.layer.cornerRadius = CORNER_RADIUS
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
}

extension UIStackView {
  private static func makeStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.distribution  = .equalSpacing
    stackView.alignment = .fill
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }
  
  static func makeVerticalStackView() -> UIStackView {
    let stackView = UIStackView.makeStackView()
    stackView.axis = NSLayoutConstraint.Axis.vertical
    return stackView
  }
  
  static func makeHorizontalStackView() -> UIStackView {
    let stackView = UIStackView.makeStackView()
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    return stackView
  }
}

extension UILabel {
  static func makeTitleLabel() -> UILabel {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = .label
    label.minimumScaleFactor = 0.9
    label.adjustsFontSizeToFitWidth   = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  static func makeSecondaryLabel() -> UILabel {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.90
    label.lineBreakMode = .byTruncatingTail
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  static func makeBodyLabel() -> UILabel {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.textColor = .secondaryLabel
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.75
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.sizeToFit()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
}

extension UIImageView {
  static func makeImageView(defaultImageName: String) -> UIImageView {
    let iv = UIImageView()
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleToFill
    iv.clipsToBounds = true
    iv.image = UIImage(named: defaultImageName)
    iv.layer.cornerRadius = 10
    return iv
  }
}

extension UISegmentedControl {
  static func makeSegmentedControl() -> UISegmentedControl {
    let sControl = UISegmentedControl()
    sControl.frame = CGRect(x: 10, y: 150, width: 500, height: 50)
    sControl.selectedSegmentIndex = 0
    sControl.selectedSegmentTintColor = .mainTheme
    sControl.layer.cornerRadius = CORNER_RADIUS
    
    sControl.setTitleTextAttributes(
      [NSAttributedString.Key.foregroundColor: UIColor.mainTheme],
      for: .normal
    )
    sControl.setTitleTextAttributes(
      [NSAttributedString.Key.foregroundColor: UIColor.white],
      for: .selected
    )
    
    sControl.translatesAutoresizingMaskIntoConstraints = false
  
    return sControl
  }
}

extension UICollectionView {
  static func makeHorizontalCollectionView() -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
  
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.showsHorizontalScrollIndicator = true
    cv.isPagingEnabled = true
    cv.bounces = true
    cv.alwaysBounceHorizontal = true
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.backgroundColor = .systemBackground

    return cv
  }
}
