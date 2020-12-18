import UIKit

class MessageInputView: UIView {

  public let sendButton = UIButton.makeContinueButton()
  
  public let textView = UITextView.makeTextView()
  private let stackView = UIStackView.makeHorizontalStackView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .systemGray3
    
    sendButton.setTitle("Send", for: .normal)
    stackView.addArrangedSubview(textView)
    stackView.addArrangedSubview(sendButton)
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -7),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension MessageInputView: UITextViewDelegate {
  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    return true
  }
}
