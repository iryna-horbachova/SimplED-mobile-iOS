import UIKit

class GroupVideoChatViewController: UIViewController {
  
  let videoView = UIView()
  let leaveButton = UIButton.makeSecondaryButton(title: "Leave call")
  let participantsCollectionView = UICollectionView.makeHorizontalCollectionView()
  let participantCellIdentifier = "participantCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    videoView.translatesAutoresizingMaskIntoConstraints = false
    
    participantsCollectionView.dataSource = self
    participantsCollectionView.delegate = self
    participantsCollectionView.register(ParticipantVideoCell.self,
                            forCellWithReuseIdentifier: participantCellIdentifier)
    
    view.addSubview(videoView)
    view.addSubview(leaveButton)
    view.addSubview(participantsCollectionView)
    videoView.backgroundColor = .red
    
    NSLayoutConstraint.activate(
      [
        participantsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        participantsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        participantsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        participantsCollectionView.heightAnchor.constraint(equalToConstant: 200),
        
        leaveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        leaveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        leaveButton.bottomAnchor.constraint(equalTo: participantsCollectionView.topAnchor),
        leaveButton.heightAnchor.constraint(equalToConstant: 40),
        
        videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PADDING),
        videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        videoView.bottomAnchor.constraint(equalTo: leaveButton.topAnchor),
      ])
  }
}

extension GroupVideoChatViewController: UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: participantCellIdentifier,
                                                  for: indexPath) as! ParticipantVideoCell

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: collectionView.bounds.height)
  }
}

