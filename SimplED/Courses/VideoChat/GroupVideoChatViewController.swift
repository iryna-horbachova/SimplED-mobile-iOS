import UIKit
import AgoraRtcKit
import Keys

class GroupVideoChatViewController: UIViewController {
  
  // UI Setup
  let videoView = UIView()
  let leaveButton = UIButton.makeSecondaryButton(title: "Leave call")
  let participantsCollectionView = UICollectionView.makeHorizontalCollectionView()
  let participantCellIdentifier = "participantCell"
  
  // Agora Setup
  
  let appID = "a9f5c4461deb4586ae253047f2bc342e" //SimplEDKeys().agoraAppID
  var agoraKit: AgoraRtcEngineKit?

  var userID: UInt = 1
  var channelName = "default"
  var remoteUserIDs: [UInt] = []
  
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
    
    setUpVideo()
    joinChannel()
  }
  
  // - MARK: Agora management
  
  // Entry point to Agora
  private func getAgoraEngine() -> AgoraRtcEngineKit {
    if agoraKit == nil {
      agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
    }
      
    return agoraKit!
  }
  
  func setUpVideo() {
    getAgoraEngine().enableVideo()
    
    let videoCanvas = AgoraRtcVideoCanvas()
    videoCanvas.uid = userID
    videoCanvas.view = videoView
    videoCanvas.renderMode = .fit
    getAgoraEngine().setupLocalVideo(videoCanvas)
  }

  func joinChannel() {
    videoView.isHidden = false
    print("join channel")
    
    getAgoraEngine().joinChannel(byToken: nil,
                                 channelId: channelName,
                                 info: nil,
                                 uid: userID) { [weak self] (sid, uid, elapsed) in
      self?.userID = uid
      print("success")
      print(self?.userID)
    }
  }

}

extension GroupVideoChatViewController: UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return remoteUserIDs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    /*let cell = collectionView.dequeueReusableCell(withReuseIdentifier: participantCellIdentifier,
     for: indexPath) as! ParticipantVideoCell
     
     return cell*/
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: participantCellIdentifier, for: indexPath)
    
    let remoteID = remoteUserIDs[indexPath.row]
    if let videoCell = cell as? ParticipantVideoCell {
      let videoCanvas = AgoraRtcVideoCanvas()
      videoCanvas.uid = remoteID
      videoCanvas.view = videoCell.videoView
      videoCanvas.renderMode = .fit
      getAgoraEngine().setupRemoteVideo(videoCanvas)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: collectionView.bounds.height)
  }
}

extension GroupVideoChatViewController: AgoraRtcEngineDelegate {
  func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
    remoteUserIDs.append(uid)
    print("hello")
    participantsCollectionView.reloadData()
  }
  
  //Sometimes, user info isn't immediately available when a remote user joins - if we get it later, reload their nameplate.
  func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
    if let index = remoteUserIDs.first(where: { $0 == uid }) {
      participantsCollectionView.reloadItems(at: [IndexPath(item: Int(index), section: 0)])
      print("hello2")
    }
  }
  
  func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
    if let index = remoteUserIDs.firstIndex(where: { $0 == uid }) {
      remoteUserIDs.remove(at: index)
      print("hello3")
      participantsCollectionView.reloadData()
    }
  }
}

