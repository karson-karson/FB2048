//
//  SoundTarget.swift
//  FB2048
//
//  Created by Justin on 4/8/25.
//

import Foundation
import AVKit

public enum SoundTarget: CaseIterable {
   
    case lose
    case win
    case transition
    
    var id: String {
        switch self {
        case .lose:
            return "lose"
        case .win:
            return "win"
        case .transition:
            return "transition"
        }
    }
    
    var resourceURL: URL? {
        let resourceName: String
        switch self {
        case .lose:
            resourceName = "Lose"
        case .win:
            resourceName = "Win"
        case .transition:
            resourceName = "Transition"
        }
        return Bundle(for: FB2048Bundle.self).url(forResource: resourceName, withExtension: ".mp3")
    }
}

public class NNSoundService {
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private var lastPlayer: AVAudioPlayer?
    
    private(set) var volume: Float = 1.0
    
    public static let shared = NNSoundService()
    
    private init () {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // Important for respecting silent mode and allowing audio playback
            try audioSession.setCategory(.playback, mode: .default, options: [.duckOthers])
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    @discardableResult
    private func createAudioPlayer(for target: SoundTarget) -> AVAudioPlayer? {
        guard let resourceURL = target.resourceURL else {
            return nil
        }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: resourceURL)
            audioPlayer.volume = volume
            audioPlayer.prepareToPlay() // Preload the sound
            audioPlayers[target.id] = audioPlayer // Store in the dictionary with the ID as the key
            return audioPlayer
        }
        catch {
            print("Error loading sound \(target.id): \(error)")
            return nil
        }
    }
    
    public func preloadSounds(targets: [SoundTarget]) {
        for target in targets {
            createAudioPlayer(for: target)
        }
    }
    
    public func playSound(_ target: SoundTarget) {
        lastPlayer?.stop()
        lastPlayer?.currentTime = 0
        if let audioPlayer = audioPlayers[target.id] {
            audioPlayer.play()
            lastPlayer = audioPlayer
        } else {
            let player = createAudioPlayer(for: target)
            player?.play()
            lastPlayer = player
        }
    }
    
    public func stopSound(_ target: SoundTarget) {
        if let audioPlayer = audioPlayers[target.id] {
            audioPlayer.stop()
        }
    }
    
    public func cleanUp() {
        audioPlayers.removeAll()
    }
    
    public func setVolume(_ volume: Float) {
        self.volume = volume
        self.audioPlayers.values.forEach { $0.volume = volume }
    }
}
