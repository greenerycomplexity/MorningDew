//
//  SoundPlayer.swift
//  MorningDew
//
//  Created by Son Cao on 15/2/2024.
//

import Foundation
import AVFoundation
var audioPlayer: AVAudioPlayer!

struct SoundPlayer {

    func play(file: String) {
        let path = Bundle.main.path(forResource: file, ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            //create your audioPlayer in your parent class as a property
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("couldn't load the file")
        }
    }
}
