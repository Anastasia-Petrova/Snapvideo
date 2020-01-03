import UIKit
import AVFoundation
import QuickLook

class VideoEditorViewController: UIViewController {
    let player: AVPlayer
    let playerLayer: AVPlayerLayer
    let playerView = UIView()
    let effectsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let dataSource = EffectsCollectionViewDataSource()
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?.withRenderingMode(.alwaysTemplate))
    let bgLayer: AVPlayerLayer
    var playerRateObservation: NSKeyValueObservation?
    var slider = UISlider()
    var effectsButton = UIButton()
    let timerLabel = UILabel()
    var cancelButton = UIButton()
    var doneButton = UIButton()
    var bottomCollectionViewconstraint = NSLayoutConstraint()
    
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
        effectsCollectionView.dataSource = dataSource
        effectsCollectionView.register(EffectsCollectionViewCell.self, forCellWithReuseIdentifier: "effectsCollectionViewCell")
        setUpBackgroundView()
        setUpPlayerView()
        setUpResumeButton()
        setUpPlayer()
        setUpSlider()
        setUpEffectsButton()
        setUpTimer()
        setUpCollectionView()
        setUpCancelButton()
//        setUpDoneButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.frame
        bgLayer.frame = view.frame
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpPlayer() {
        //1 Подписка на событие достижения конца видео
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        //2 Подписка на изменение рейта плейера - (играю/не играю)
        playerRateObservation = player.observe(\.rate) { [weak self] (_, _) in
            guard let self = self else { return }
            self.resumeImageView.isHidden = self.player.rate > 0
        }
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 100), queue: .main) { [weak self] time in
            self?.slider.value = Float(time.seconds)
            self?.updateTimer()
        }
    }
    
    func setUpResumeButton() {
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
        resumeImageView.isHidden = false
    }
    
    func setUpSlider() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(slider)
        NSLayoutConstraint.activate ([
        slider.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 50),
        slider.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -50),
        slider.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -50)])
        slider.minimumValue = 0
        guard let trackDuration = player.currentItem?.asset.duration else {
            return
        }
        slider.maximumValue = Float(CMTimeGetSeconds(trackDuration))
//        slider.value = {}
        slider.addTarget(self, action: #selector(self.sliderAction), for: .valueChanged)
    }
    
    func setUpPlayerView() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)
        NSLayoutConstraint.activate ([
        playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        playerView.topAnchor.constraint(equalTo: self.view.topAnchor)])
        playerView.layer.addSublayer(playerLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        playerView.addGestureRecognizer(tap)
    }
    
    func setUpTimer() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(timerLabel)
        NSLayoutConstraint.activate ([
        timerLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        timerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
        timerLabel.heightAnchor.constraint(equalToConstant: 44)])
        timerLabel.alpha = 0.5
        timerLabel.textColor = .white
        guard let trackDuration = player.currentItem?.asset.duration else {
            return
        }
        let videoDuration = Int(CMTimeGetSeconds(trackDuration))
        timerLabel.text = "\(formatMinuteSeconds(videoDuration))"
    }
    
    func updateTimer() {
        let duraion = Int(CMTimeGetSeconds(player.currentTime()))
        let timeString = formatMinuteSeconds(duraion)
        timerLabel.text = "\(timeString)"
    }
    
    func formatMinuteSeconds(_ totalSeconds: Int) -> String {
        let hours  = totalSeconds / 3600
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds);
    }
    
    func setUpCollectionView() {
//        let effectsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        effectsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(effectsCollectionView)
        bottomCollectionViewconstraint = effectsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 150)
        NSLayoutConstraint.activate ([
        effectsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        effectsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        bottomCollectionViewconstraint,
        effectsCollectionView.heightAnchor.constraint(equalToConstant: 150),
        playerView.bottomAnchor.constraint(equalTo: effectsCollectionView.topAnchor)
//        effectsCollectionView.topAnchor.constraint(equalTo: playerView.bottomAnchor)
        ])
        effectsCollectionView.backgroundColor = .blue
    }
    
    func setUpBackgroundView() {
        self.view.layer.addSublayer(bgLayer)
        bgLayer.videoGravity = .resizeAspectFill
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self.view.addSubview(visualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: visualEffectView.leftAnchor),
            view.rightAnchor.constraint(equalTo: visualEffectView.rightAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor)])
    }
    
    func setUpEffectsButton() {
        effectsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effectsButton)
        NSLayoutConstraint.activate ([
            effectsButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        effectsButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
        effectsButton.heightAnchor.constraint(equalToConstant: 44),
        effectsButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        effectsButton.setImage(UIImage(named: "effects")?.withRenderingMode(.alwaysTemplate), for: .normal)
        effectsButton.tintColor = .white
        effectsButton.addTarget(self, action: #selector(self.openEffects), for: .touchUpInside)
    }
    
    func setUpCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        effectsCollectionView.addSubview(cancelButton)
        NSLayoutConstraint.activate ([
            cancelButton.leadingAnchor.constraint(equalTo: self.effectsCollectionView.leadingAnchor, constant: 8),
        cancelButton.topAnchor.constraint(equalTo: self.effectsCollectionView.topAnchor, constant: 8),
        cancelButton.heightAnchor.constraint(equalToConstant: 30),
        cancelButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        cancelButton.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.tintColor = .white
        cancelButton.addTarget(self, action: #selector(self.closeEffects), for: .touchUpInside)
    }
    
//    func setUpDoneButton() {
//        doneButton.translatesAutoresizingMaskIntoConstraints = false
//        effectsCollectionView.addSubview(doneButton)
//        NSLayoutConstraint.activate ([
//        doneButton.trailingAnchor.constraint(equalTo: self.effectsCollectionView.trailingAnchor, constant: -8),
//        doneButton.topAnchor.constraint(equalTo: self.effectsCollectionView.topAnchor, constant: 8),
//        doneButton.heightAnchor.constraint(equalToConstant: 30),
//        doneButton.widthAnchor.constraint(equalToConstant: 30)
//        ])
//        doneButton.setImage(UIImage(named: "done")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        doneButton.tintColor = .black
//        doneButton.addTarget(self, action: #selector(self.saveChanges), for: .touchUpInside)
//    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    @objc func sliderAction() {
        player.seek(
            to: CMTime(
                seconds: Double(slider.value),
                preferredTimescale: 1
            ),
            toleranceBefore: CMTime.zero,
            toleranceAfter: CMTime.zero
        )
    }
    
    @objc func openEffects() {
        bottomCollectionViewconstraint.constant = 0
        effectsButton.isHidden = true
    }
    
    @objc func closeEffects() {
        bottomCollectionViewconstraint.constant = 150
        effectsButton.isHidden = false
    }
    
//    @objc func saveChanges() {
//
//    }
}

