import UIKit
import AVFoundation

class VideoEditorViewController: UIViewController {
    let asset: AVAsset
    let player: AVPlayer
    let playerView: VideoView
    let effectsView = UIView()
    let effectsCollectionView: UICollectionView
    let dataSource: EffectsCollectionViewDataSource
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?.withRenderingMode(.alwaysTemplate))
    let bgLayer: AVPlayerLayer
    var playerRateObservation: NSKeyValueObservation?
    var slider = UISlider()
    var effectsButton = UIButton()
    let timerLabel = UILabel()
    var cancelButton = UIButton()
    var doneButton = UIButton()
    var bottomEffectsConstraint = NSLayoutConstraint()
    var previewImage: UIImage? {
        didSet {
            dataSource.image = previewImage
        }
    }
    var trackDuration: Float {
        guard let trackDuration = player.currentItem?.asset.duration else {
            return 0
        }
        return Float(CMTimeGetSeconds(trackDuration))
    }
    
    init( url: URL, filters: [Filter]) {
        asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        let output = AVPlayerItemVideoOutput(outputSettings: nil)
        playerItem.add(output)
        playerView = VideoView(videoOutput: output, videoOrientation: self.asset.videoOrientation)
        bgLayer = AVPlayerLayer(player: player)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 90)
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 90, right: 10)
        layout.scrollDirection = .horizontal
        effectsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource = EffectsCollectionViewDataSource(collectionView: effectsCollectionView, filters: filters)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        AssetImageGenerator.getThumbnailImageFromVideoAsset(asset: asset, completion: { [weak self] image in
            self?.previewImage = image
        })
        setUpBackgroundView()
        setUpPlayerView()
        setUpEffectsView()
        setUpResumeButton()
        setUpPlayer()
        setUpSlider()
        setUpEffectsButton()
        setUpTimer()
        setUpCancelButton()
        setUpDoneButton()
        effectsCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
            let isPlaying = self.player.rate > 0
            self.resumeImageView.isHidden = isPlaying
            isPlaying ? self.playerView.play() :  self.playerView.pause()
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
        slider.bottomAnchor.constraint(equalTo: playerView.safeAreaLayoutGuide.bottomAnchor, constant: -50)])
        slider.minimumValue = 0
        slider.maximumValue = trackDuration
        slider.addTarget(self, action: #selector(self.sliderAction), for: .valueChanged)
    }
    
    func setUpPlayerView() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)
        NSLayoutConstraint.activate ([
        playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        playerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        playerView.addGestureRecognizer(tap)
    }
    
    func setUpTimer() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(timerLabel)
        NSLayoutConstraint.activate ([
        timerLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
        timerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
        timerLabel.heightAnchor.constraint(equalToConstant: 44)])
        timerLabel.alpha = 0.5
        timerLabel.textColor = .white
        let videoDuration = Int(trackDuration)
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
    
    func setUpEffectsView() {
        effectsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(effectsView)
        effectsView.backgroundColor = .white
        bottomEffectsConstraint = effectsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 200)
        
        NSLayoutConstraint.activate ([
        effectsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        effectsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        effectsView.topAnchor.constraint(equalTo: playerView.bottomAnchor),
        bottomEffectsConstraint,
        effectsView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let collectionStackView = UIStackView()
        collectionStackView.translatesAutoresizingMaskIntoConstraints = false
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        effectsView.addSubview(collectionStackView)
        collectionStackView.axis = .vertical
        
        NSLayoutConstraint.activate ([
            collectionStackView.trailingAnchor.constraint(equalTo: effectsView.trailingAnchor),
        collectionStackView.leadingAnchor.constraint(equalTo: effectsView.leadingAnchor),
        collectionStackView.topAnchor.constraint(equalTo: effectsView.topAnchor),
        collectionStackView.bottomAnchor.constraint(equalTo: effectsView.bottomAnchor)
        ])
        
        effectsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        effectsCollectionView.backgroundColor = .white
        collectionStackView.addArrangedSubview(effectsCollectionView)
        collectionStackView.addArrangedSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(doneButton)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 60
        
        NSLayoutConstraint.activate ([
        effectsCollectionView.heightAnchor.constraint(equalToConstant: 120),
        effectsCollectionView.leadingAnchor.constraint(equalTo: effectsView.leadingAnchor, constant: 8),
        effectsCollectionView.trailingAnchor.constraint(equalTo: effectsView.trailingAnchor, constant: -8)
        ])
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
            effectsButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
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
        NSLayoutConstraint.activate ([
//        cancelButton.leadingAnchor.constraint(equalTo: effectsView.leadingAnchor, constant: 70),
//        cancelButton.bottomAnchor.constraint(equalTo:
//            effectsView.topAnchor, constant: 40),
        cancelButton.heightAnchor.constraint(equalToConstant: 20),
        cancelButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        cancelButton.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.tintColor = .gray
        cancelButton.addTarget(self, action: #selector(self.closeEffects), for: .touchUpInside)
    }
    
    func setUpDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate ([
//        doneButton.trailingAnchor.constraint(equalTo: effectsView.trailingAnchor, constant: -70),
//        doneButton.topAnchor.constraint(equalTo: effectsView.bottomAnchor, constant: 40),
        doneButton.heightAnchor.constraint(equalToConstant: 20),
        doneButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        doneButton.setImage(UIImage(named: "done")?.withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .gray
        doneButton.addTarget(self, action: #selector(self.saveVideo), for: .touchUpInside)
    }
    
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
        bottomEffectsConstraint.constant = 0
        effectsButton.isHidden = true
    }
    
    @objc func closeEffects() {
        bottomEffectsConstraint.constant = 200
        effectsButton.isHidden = false
    }
    
    @objc func saveVideo() {
        
    }
}

extension VideoEditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.playerView.filter = dataSource.filters[indexPath.row]
            collectionView.reloadItems(at: [indexPath])
    }
    
}
