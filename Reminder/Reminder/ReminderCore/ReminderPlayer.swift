//
//  ReminderPlayer.swift
//  Reminder
//
//  Created by Akhilesh Amle on 02/05/21.
//

import UIKit
import MediaPlayer

class ReminderPlayer: NSObject {

    var player : AVAudioPlayer?
    
    override init() {
        super.init()
        self.setup()
    }
    
    private func setup() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func play() {
        if self.player?.isPlaying == true {
            return
        }
        guard let path = Bundle.main.path(forResource: "tingx2.mp3", ofType: nil), let url = URL(string: path) else { return }
        self.player = try? AVAudioPlayer(contentsOf: url, fileTypeHint:AVFileType.mp3.rawValue)
        self.player?.play()
    }
    
    func stop() {
        self.player?.stop()
        self.player = nil
    }
}
