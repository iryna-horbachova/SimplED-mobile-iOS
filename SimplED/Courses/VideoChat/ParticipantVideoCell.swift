import UIKit

class ParticipantVideoCell: UICollectionViewCell {
  var videoView = UIView(frame: .zero)
  let nameLabel = UILabel.makeSecondaryLabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    videoView.translatesAutoresizingMaskIntoConstraints = false
    videoView.backgroundColor = .green

    nameLabel.text = "Name"
    addSubview(videoView)
    /*let stackView = UIStackView.makeVerticalStackView()

    stackView.addArrangedSubview(videoView)
    stackView.addArrangedSubview(nameLabel)
    stackView.spacing = 2
    stackView.distribution = .equalCentering*/
    //addSubview(stackView)

    NSLayoutConstraint.activate(
      [
        videoView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
        videoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
        videoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
        videoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
