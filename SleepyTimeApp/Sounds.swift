//
//  Sounds.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 3/12/24.
//

import Foundation
import AVFoundation

class Sounds{
    
    static var audioPlayer:AVAudioPlayer?
    static func playsSounds(soundfile:String){
        if let path = Bundle.main.path(forResource: soundfile, ofType: nil){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }catch{
                print("Error")
            }
        }
    }
    
    static func stopSound(){
        audioPlayer?.stop()
        audioPlayer = nil;
    }
}
