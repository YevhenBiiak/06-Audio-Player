//
//  PlayingNowView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class PlayingNowView: UIView {
    private lazy var blurredView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.image = AppConstants.emptyCover
        imageView.image?.withTintColor(.white)
        imageView.layer.cornerRadius = 7
        return imageView
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let playPauseButton: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        config.image = UIImage(systemName: "play.fill")
        config.baseForegroundColor = UIColor.white
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let nextTrackButton: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        config.image = UIImage(systemName: "forward.fill")
        config.baseForegroundColor = UIColor.white
        let button = UIButton(configuration: config)
        return button
    }()
    
    // MARK: - Properties
    
    var song: Song? {
        didSet {
            coverImage.image = song?.cover ?? AppConstants.emptyCover
            trackLabel.text = song?.track
        }
    }
    
    var tapHandler: (() -> Void)?
    var playButtonHandler: (() -> Void)?
    var nextButtonHandler: (() -> Void)?
    
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
        self.addBorder(at: .top, color: .darkGray, width: 0.5, topInset: 80)
    }
    
    // MARK: - Helpers methods
    
    private func setupViews() {
        addSubviews()
        addConstraints()
        setupHandlers()
    }
    
    private func setupHandlers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playingNowTapped))
        self.addGestureRecognizer(tapGesture)
        
        let playAction = UIAction { [unowned self] _ in
            print(1)
            playButtonHandler?()
            playPauseButton.setNeedsUpdateConfiguration()
        }
        playPauseButton.addAction(playAction, for: .touchUpInside)
        playPauseButton.configurationUpdateHandler = { button in
            var conf = button.configuration
            conf?.image = UIImage(systemName: "pause.fill")
            button.configuration = conf
        }
        
        let nextAction = UIAction { [unowned self] _ in
            nextButtonHandler?()
        }
        nextTrackButton.addAction(nextAction, for: .touchUpInside)
    }
    
    @objc private func playingNowTapped() {
        
    }
    
    @objc private func playButttonTapped() {
        
    }
    
    @objc private func nextButtonTapped() {
        
    }
    
    private func addSubviews() {
        self.addSubview(blurredView)
        self.addSubview(coverImage)
        self.addSubview(trackLabel)
        self.addSubview(playPauseButton)
        self.addSubview(nextTrackButton)
    }
    
    private func addConstraints() {
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
    
    // method to call from SongListiewController
    func setConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        self.topAnchor.constraint(equalTo: superview.safeBottomAnchor, constant: -80).isActive = true
        self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}
