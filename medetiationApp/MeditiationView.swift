import SwiftUI
import Combine
import AudioToolbox

struct MeditationView: View {
    let duration: Int
    let soundName: String?
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var timeRemaining: Int
    @State private var isRunning: Bool = false
    @State private var isFinished: Bool = false
    @State private var isBreathing: Bool = false
    

    @State private var timerCancellable: Cancellable?
    
    func playBell() {
        AudioServicesPlaySystemSound(1104)
    }
    
    init(duration: Int, soundName: String? = nil) {
        self.duration = duration
        self.soundName = soundName
        _timeRemaining = State(initialValue: duration * 60)
    }
    
    var body: some View {
        ZStack {
        
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .statusBar(hidden: true)
            .navigationBarHidden(true)

            
            VStack {
                HStack {
                    GlassBackButton {
                        audioManager.stopSound()
                        dismiss()
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top)

                Spacer()
            }

            
     
            if !isFinished {
                Circle()
                    .fill(Color.white.opacity(0.4))
                    .blur(radius: 15)
                    .frame(width: 220, height: 220)
                    .scaleEffect(isBreathing ? 1.5 : 1.0)
                    .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: isBreathing)
            }
   
            VStack(spacing: 40) {
                Spacer()
                
                Text(isFinished ? "Session Complete" : "Breathe")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(.white.opacity(0.9))
                
                // Timer Text
                Text(timeString)
                    .font(.system(size: 70, weight: .thin, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .shadow(color: .black.opacity(0.2), radius: 10)
                
                Spacer()
                
                Button {
                    if isFinished {
                        resetTimer()
                    } else {
                        toggleTimer()
                    }
                } label: {
                    Text(buttonLabel)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(isFinished ? .white : .purple)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Capsule()
                                .fill(isFinished ? Color.clear : Color.white)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white, lineWidth: isFinished ? 2 : 0)
                                )
                        )
                        .padding(.horizontal, 40)
                }
                
                Spacer().frame(height: 70)
            }
        }
        .onAppear {
      
            if soundName != nil && soundName != "None" {
       
            }
        }
       
    }
    
    // MARK: - Logic
    
    private var buttonLabel: String {
        if isFinished { return "Done" }
        return isRunning ? "Pause" : "Start"
    }
    
    private func toggleTimer() {
        isRunning.toggle()
        
       
        if isRunning {
            isBreathing = true
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    self.tick()
                }
        } else {
            isBreathing = false
            timerCancellable?.cancel()
        }
    }
    
    private func resetTimer() {
        audioManager.stopSound()
        dismiss()
    }
    
    private func tick() {
        guard timeRemaining > 0 else {
            finishSession()
            return
        }
        timeRemaining -= 1
    }
    
    private func finishSession() {
        isRunning = false
        isBreathing = false
        isFinished = true
        timerCancellable?.cancel() 
        playBell()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.playBell()
        }
    }
    
    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
