//
//  SongListView.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 25.06.2022.
//

import UIKit

class SongListView: UIScrollView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    var songList: [Song]? {
        didSet {
            updateSongList()
        }
    }
    
    var tapHandler: ((Int) -> Void)?
    
    // MARK: - initializers
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Help methods
    
    private func setupViews() {
        self.contentInset.bottom = 80
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func updateSongList() {
        guard let songList = songList else { return }
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        for (index, song) in songList.enumerated() {
            let songView = SongItemView(withSong: song)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(songItemTapped(gesture:)))
            songView.addGestureRecognizer(tapGesture)
            songView.tag = index
            
            songView.heightAnchor.constraint(equalToConstant: AppConstants.rowHeight).isActive = true
            stackView.addArrangedSubview(songView)
        }
    }
    
    @objc private func songItemTapped(gesture: UITapGestureRecognizer) {
        if let views = stackView.arrangedSubviews as? [SongItemView] {
            views.forEach { view in
                if view.isPlayingNow { view.isPlayingNow.toggle() }
            }
        }
        if let view = gesture.view as? SongItemView {
            view.isPlayingNow = true
            tapHandler?(view.tag)
        }
    }
    
    func setConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        self.topAnchor.constraint(equalTo: superview.safeTopAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}
