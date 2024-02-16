//
//  SoundPlayer.swift
//  MorningDew
//
//  Created by Son Cao on 15/2/2024.
//

import AVFoundation
import Foundation

var audioPlayer: AVAudioPlayer!
var musicPlayer: AVAudioPlayer!

struct SoundPlayer {
    func play(file: String) {
        let path = Bundle.main.path(forResource: file, ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("Couldn't load the file")
        }
    }
}

struct MusicPlayer {
    func play(file: String, volume: Float = 1) {
        let path = Bundle.main.path(forResource: file, ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer.volume = volume
            musicPlayer.play()
        } catch {
            print("Couldn't load the file")
        }
    }
}
