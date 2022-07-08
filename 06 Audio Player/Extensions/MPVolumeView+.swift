//
//  MPVolumeView+.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 08.07.2022.
//

import MediaPlayer

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.clipsToBounds = true
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
