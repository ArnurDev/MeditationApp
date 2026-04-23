import SwiftUI

struct SoundSelectionView: View {
    let duration: Int

    @State private var selectedSound: String? = nil
    @StateObject var audioManager = AudioManager()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {

                // Custom Back Button
                HStack {
                    GlassBackButton {
                        audioManager.stopSound()
                        dismiss()
              
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Title
                Text("Choose Vibe")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Select a background sound")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

     
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 20
                ) {
                    ForEach(
                        ["Rain", "Cat", "White Noise", "Fire", "Ocean", "None"],
                        id: \.self
                    ) { sound in
                        Button {
                            handleSoundSelection(sound)
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: getIcon(for: sound))
                                    .font(.system(size: 30))
                                    .foregroundColor(
                                        selectedSound == sound ? .purple : .white
                                    )

                                Text(sound)
                                    .font(.caption)
                                    .foregroundColor(
                                        selectedSound == sound ? .purple : .white
                                    )
                            }
                            .frame(width: 100, height: 100)
                            .background(
                                selectedSound == sound
                                ? Color.white
                                : Color.white.opacity(0.2)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                }
                .padding()

                Spacer()

              
                NavigationLink(
                    destination: MeditationViewWrapper(
                        duration: duration,
                        soundName: selectedSound,
                        audioManager: audioManager
                    )
                ) {
                    Text("Start Session")
                        .font(.headline)
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding(.horizontal, 40)
                        .shadow(radius: 5)
                }
                .disabled(selectedSound == nil)
                .opacity(selectedSound == nil ? 0.5 : 1)

                Spacer().frame(height: 40)
            }
        }
        .navigationBarHidden(true)
    }

   

    private func handleSoundSelection(_ sound: String) {
        selectedSound = sound
        audioManager.stopSound()

        if sound != "None" {
            audioManager.playSound(soundName: sound)
        }
    }

    private func getIcon(for sound: String) -> String {
        switch sound {
        case "Rain": return "cloud.rain"
        case "Cat": return "pawprint"
        case "WhiteNoise": return "waveform"
        case "Fire": return "flame"
        case "Ocean": return "water.waves"
        case "None": return "speaker.slash"
        default: return "speaker.wave.2"
        }
    }
}



struct MeditationViewWrapper: View {
    let duration: Int
    let soundName: String?

    @ObservedObject var audioManager: AudioManager

    var body: some View {
        MeditationView(duration: duration, soundName: soundName)
            .environmentObject(audioManager)
    }
}
