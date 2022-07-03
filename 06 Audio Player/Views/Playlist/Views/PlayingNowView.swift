//
//  PlayingNowView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class PlayingNowView: UIView {
    private lazy var blurredView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let playPauseButton: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        config.image = UIImage(systemName: "play.fill")
        config.baseForegroundColor = UIColor.secondaryLabel
        let button = UIButton(configuration: config)
        return button
    }()
    
    let nextTrackButton: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        config.image = UIImage(systemName: "forward.fill")
        config.baseForegroundColor = UIColor.secondaryLabel
        let button = UIButton(configuration: config)
        return button
    }()
    
    // MARK: - Properties
    
    var song: Song! {
        didSet {
            coverImage.image = song.cover ?? AppConstants.emptyCover
            trackLabel.text = song.track
        }
    }
    
    var isPlaying: Bool = false {
        didSet {
            playPauseButton.configurationUpdateHandler?(playPauseButton)
        }
    }
    
    // MARK: - Initializers and override methods
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addBorder(at: .top, color: .systemGray4, width: 0.5, topInset: AppConstants.playingNowHeight)
        coverImage.layer.cornerRadius = 5
        coverImage.layer.masksToBounds = true
    }
    
    // MARK: - Helper initialization methods
    
    private func setupViews() {
        addSubviews()
        setConstraints()
        configurePlayPausButton()
    }
    
    private func addSubviews() {
        self.addSubview(blurredView)
        self.addSubview(coverImage)
        self.addSubview(trackLabel)
        self.addSubview(playPauseButton)
        self.addSubview(nextTrackButton)
    }
    
    private func setConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        nextTrackButton.translatesAutoresizingMaskIntoConstraints = false
        
        trackLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        self.addConstraints(H: "|-10-[coverImage(58)]-8-[trackLabel]->=8-[playPauseButton]-8-[nextTrackButton]-16-|")
        self.addConstraints(V: "|-10-[coverImage(58)]")
        self.addConstraints(V: "|-30-[trackLabel]")
        self.addConstraints(V: "|-24-[playPauseButton]")
        self.addConstraints(V: "|-24-[nextTrackButton]")
    }
    
    private func configurePlayPausButton() {
        playPauseButton.configurationUpdateHandler = { [unowned self] button in
            if button.state == .normal {
                var config = button.configuration
                config?.image = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
                button.configuration = config
            }
        }
    }
}
