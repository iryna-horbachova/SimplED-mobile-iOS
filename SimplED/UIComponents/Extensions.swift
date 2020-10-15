import UIKit

extension UIColor {
  convenience init(r: Int, g: Int, b: Int) {
    self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
  }
  
  static var mainTheme: UIColor {
    return UIColor(r: 1, g: 186, b: 239)
  }
}

extension UITextField {
  static func makeTextField() -> UITextField {
    let textField =  UITextField()
    textField.font = .systemFont(ofSize: 22)
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.textColor = .mainTheme
    textField.backgroundColor = .white
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
}

extension UIStackView {
  static func makeVerticalStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis  = NSLayoutConstraint.Axis.vertical
    stackView.distribution  = .equalSpacing
    stackView.alignment = .fill
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }
}
