//
//  SoundManager.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 04/02/24.
//

import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound(name: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Sound player error: \(error.localizedDescription)")
        }
    }
}
