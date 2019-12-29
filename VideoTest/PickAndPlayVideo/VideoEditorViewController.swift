import UIKit
import AVFoundation

class VideoEditorViewController: UIViewController {
    let player: AVPlayer
    let playerLayer: AVPlayerLayer
    let playerView = UIView()
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?.withRenderingMode(.alwaysTemplate))
    let bgLayer: AVPlayerLayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
        self.playerLayer = AVPlayerLayer(player: player)
        self.bgLayer = AVPlayerLayer(player: player)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.layer.addSublayer(bgLayer)
        bgLayer.videoGravity = .resizeAspectFill
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self.view.addSubview(visualEffectView)
        self.view.addSubview(playerView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: visualEffectView.leftAnchor),
            view.rightAnchor.constraint(equalTo: visualEffectView.rightAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor)])
        NSLayoutConstraint.activate ([
        playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        playerView.topAnchor.constraint(equalTo: self.view.topAnchor),
        playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        playerView.layer.addSublayer(playerLayer)
        resumeImageView.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(resumeImageView)
        NSLayoutConstraint.activate([
        resumeImageView.centerYAnchor.constraint(equalTo: playerView.centerYAnchor),
        resumeImageView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
        resumeImageView.heightAnchor.constraint(equalToConstant: 70),
        resumeImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        resumeImageView.tintColor = .white
        resumeImageView.isUserInteractionEnabled = false
        resumeImageView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.frame
        bgLayer.frame = view.frame
    }
      
}
