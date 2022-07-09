//
//  PlayerView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit
import MediaPlayer

protocol PlayerViewDelegate: AnyObject {
    func playerView(_ playerView: PlayerView, didTapPlayModeButton button: UIButton)
    func playerView(_ playerView: PlayerView, didTapPreviousButton button: UIButton)
    func playerView(_ playerView: PlayerView, didTapPlayPauseButton button: UIButton)
    func playerView(_ playerView: PlayerView, didTapNextButton button: UIButton)
    func playerView(_ playerView: PlayerView, didChangeSeekSlider slider: UISlider)
    func playerView(_ playerView: PlayerView, didChangeVolumeSlider slider: UISlider)
}

class PlayerView: UIView {
    private lazy var blurredView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    private let grabbeImageView: UIImageView = {
        let size = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 50))
        let color = UIImage.SymbolConfiguration(hierarchicalColor: UIColor.systemGray)
        let config = size.applying(color)
        let image = UIImage(systemName: "minus", withConfiguration: config)!
        return UIImageView(image: image)
    }()
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.backgroundColor = .systemGray5
        imageView.image = AppConstants.defaultArtwork
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    private let playModeButton: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.baseForegroundColor = .secondaryLabel
        let button = UIButton(configuration: config)
        return button
    }()
        
    private let seekSlider: UISlider = {
        let thumb: UIImage = {
            let size = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 10))
            let color = UIImage.SymbolConfiguration(hierarchicalColor: UIColor.white)
            let config = size.applying(color)
            let image = UIImage(systemName: "circle.fill", withConfiguration: config)!
            return image
        }()
        let slider = UISlider()
        slider.setThumbImage(thumb, for: .normal)
        slider.minimumTrackTintColor = .systemGray
        return slider
    }()
    
    private let elapsedTimeLabel: UILabel = {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attrString = NSAttributedString(string: "0:00", attributes: attributes)
        let label = UILabel()
        label.attributedText = attrString
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attrString = NSAttributedString(string: "0:00", attributes: attributes)
        let label = UILabel()
        label.attributedText = attrString
        return label
    }()
    
    private let previousSongButton: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 25))
        config.image = UIImage(systemName: "backward.fill")
        config.baseForegroundColor = .label
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 35))
        config.image = UIImage(systemName: "play.fill")
        config.baseForegroundColor = .label
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let nextSongButton: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 25))
        config.image = UIImage(systemName: "forward.fill")
        config.baseForegroundColor = .label
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .systemGray
        slider.minimumTrackTintColor = .systemGray
        slider.minimumValueImage = UIImage(systemName: "speaker.fill")
        slider.maximumValueImage = UIImage(systemName: "speaker.wave.3.fill")
        return slider
    }()
    
    private var detailStack: UIStackView!
    
    // MARK: - Properties
    
    private weak var delegate: PlayerViewDelegate?
    
    var isPlaying: Bool! {
        didSet {
            playPauseButton.configurationUpdateHandler?(playPauseButton)
            animateCoverImage()
        }
    }
    
    // MARK: - Initializers and overridden methods
    
    init(delegate: PlayerViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        coverImage.layer.cornerRadius = 10
        coverImage.layer.masksToBounds = true
    }
    
    // MARK: - Helper initialization methods
    
    private func setupViews() {
        detailStack = configureDetailStack()
        addSubviews()
        setConstraints()
        addActions()
        configureButtons()
    }
    
    private func configureDetailStack() -> UIStackView {
        // vertical stack with title and artist
        let vStack = UIStackView()
        vStack.distribution = .equalCentering
        vStack.axis = .vertical
        [titleLabel, artistLabel].forEach { vStack.addArrangedSubview($0) }
        
        // horizontal stack with title, artist and playmode button
        let hStack = UIStackView()
        hStack.distribution = .equalCentering
        hStack.axis = .horizontal
        [vStack, playModeButton].forEach { hStack.addArrangedSubview($0) }
        
        return hStack
    }
    
    private func addSubviews() {
        addSubview(blurredView)
        addSubview(grabbeImageView)
        addSubview(coverImage)
        addSubview(detailStack)
        addSubview(seekSlider)
        addSubview(elapsedTimeLabel)
        addSubview(remainingTimeLabel)
        addSubview(playPauseButton)
        addSubview(nextSongButton)
        addSubview(previousSongButton)
        addSubview(volumeSlider)
    }
    
    private func setConstraints() {
        grabbeImageView.translatesAutoresizingMaskIntoConstraints = false
        detailStack.translatesAutoresizingMaskIntoConstraints = false
        seekSlider.translatesAutoresizingMaskIntoConstraints = false
        elapsedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        nextSongButton.translatesAutoresizingMaskIntoConstraints = false
        previousSongButton.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(H: "|~[grabbeImageView]~|", V: "|-(-10)-[grabbeImageView]")
        addConstraints(H: "|-30-[detailStack]-30-|", V: "[detailStack(50)]")
        addConstraints(H: "|-30-[seekSlider]-30-|", V: "[detailStack]-20-[seekSlider]")
        addConstraints(H: "|-30-[elapsedTimeLabel]", V: "[seekSlider]-[elapsedTimeLabel]")
        addConstraints(H: "[remainingTimeLabel]-30-|", V: "[seekSlider]-[remainingTimeLabel]")
        addConstraints(H: "|~[playPauseButton]~|")
        addConstraints(H: "[nextSongButton]-50-|")
        addConstraints(H: "|-50-[previousSongButton]")
        playPauseButton.centerYAnchor.constraint(equalTo: seekSlider.centerYAnchor, constant: 80).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: volumeSlider.centerYAnchor, constant: -80).isActive = true
        nextSongButton.centerYAnchor.constraint(equalTo: seekSlider.centerYAnchor, constant: 80).isActive = true
        previousSongButton.centerYAnchor.constraint(equalTo: seekSlider.centerYAnchor, constant: 80).isActive = true
        addConstraints(H: "|-30-[volumeSlider]-30-|", V: "[volumeSlider]-160-|")
    }
    
    private func addActions() {
        playModeButton.addAction(UIAction { [unowned self] _ in
            delegate?.playerView(self, didTapPlayModeButton: playModeButton)
        }, for: .touchUpInside)
        
        previousSongButton.addAction(UIAction { [unowned self] _ in
            delegate?.playerView(self, didTapPreviousButton: previousSongButton)
        }, for: .touchUpInside)
        
        playPauseButton.addAction(UIAction { [unowned self] _ in
            delegate?.playerView(self, didTapPlayPauseButton: playPauseButton)
        }, for: .touchUpInside)
        
        nextSongButton.addAction(UIAction { [unowned self] _ in
            delegate?.playerView(self, didTapNextButton: nextSongButton)
        }, for: .touchUpInside)
        
        seekSlider.addAction(UIAction { [unowned self] _ in
            elapsedTimeLabel.text = Double(seekSlider.value).stringRepresentationOfTime()
        }, for: .valueChanged)
        
        seekSlider.addAction(UIAction { [unowned self] _ in
            delegate?.playerView(self, didChangeSeekSlider: seekSlider)
        }, for: [.touchUpInside, .touchUpOutside])
        
        volumeSlider.addAction(UIAction { [unowned self] _ in
            delegate?.playerView(self, didChangeVolumeSlider: volumeSlider)
        }, for: .valueChanged)
    }
    
    private func configureButtons() {
        playPauseButton.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            if button.state == .highlighted {
                config?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 28))
            }
            if button.state == .normal {
                config?.image = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
                config?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 35))
            }
            button.configuration = config
        }
        
        nextSongButton.configurationUpdateHandler = { button in
            var config = button.configuration
            switch button.state {
            case .highlighted:
                config?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
            case .normal:
                config?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 25))
            default: break }
            button.configuration = config
        }
        
        previousSongButton.configurationUpdateHandler = nextSongButton.configurationUpdateHandler
        
        playModeButton.configurationUpdateHandler = { button in
            var config = button.configuration
            if button.state == .highlighted {
                config?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))
            }
            if button.state == .normal {
                config?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))
            }
            button.configuration = config
        }
    }
    
    private func animateCoverImage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
            if isPlaying {
                coverImage.frame = CGRect(x: 30, y: 50, width: frame.width - 60, height: frame.width - 60)
            } else {
                coverImage.frame = CGRect(x: 60, y: 80, width: frame.width - 120, height: frame.width - 120)
            }
        }, completion: nil)
    }
    
    // MARK: - Updating methods
    
    func updateSongView(with audioPlayer: AudioPlayer) {
        let song = audioPlayer.currentSong!
        
        coverImage.image = song.artwork ?? AppConstants.defaultArtwork
        titleLabel.text = song.title ?? song.url.lastPathComponent.replacingOccurrences(of: "_", with: " ")
        artistLabel.text = song.artist ?? "Unknown"
        
        seekSlider.value = 0.0
        seekSlider.maximumValue = Float(audioPlayer.duration - 0.5)
        elapsedTimeLabel.text = 0.stringRepresentationOfTime()
        remainingTimeLabel.text = audioPlayer.duration.stringRepresentationOfTime()
        
        MPNowPlayingInfoCenter.update(withAudioPlayer: audioPlayer)
    }
    
    func updateVolume(_ volume: Float) {
        volumeSlider.value = volume
    }
    
    func updateCurrentTime(_ time: TimeInterval) {
        seekSlider.value = Float(time)
        elapsedTimeLabel.text = time.stringRepresentationOfTime()
    }
    
    func updatePlayMode(_ playMode: PlayMode) {
        var config = playModeButton.configuration
        switch playMode {
            case .once: config?.image = UIImage(systemName: "arrow.clockwise")
            case .repeatPlaylist: config?.image = UIImage(systemName: "repeat")
            case .repeatSong: config?.image = UIImage(systemName: "repeat.1")
            case .shuffle: config?.image = UIImage(systemName: "shuffle")
        }
        playModeButton.configuration = config
    }
}
