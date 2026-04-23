import AVFoundation
import Foundation

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    
    let sounds = ["Rain", "Cat", "White", "Fire", "Ocean"]
    
    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Error: Could not find file \(soundName).mp3")
            return
        }
        
        do {
    
            if let player = audioPlayer, player.isPlaying {
               
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
