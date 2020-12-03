import UIKit

class ParticipantVideoCell: UICollectionViewCell {
  var videoView = UIView(frame: .zero)
  let nameLabel = UILabel.makeSecondaryLabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    videoView.translatesAutoresizingMaskIntoConstraints = false
    videoView.backgroundColor = .systemBlue

    addSubview(videoView)
    addSubview(nameLabel)

    NSLayoutConstraint.activate(
      [
        videoView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
        videoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
        videoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2),
        nameLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 2),
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2),
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
