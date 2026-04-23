import SwiftUI


struct MeditationOption: Identifiable {
    let id = UUID()
    let title: String
    let duration: Int
}

struct SessionButton: View {
    let option: MeditationOption
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(option.title)
                    .font(.headline)
                          
                    .foregroundColor(.white)
                
                Text("\(option.duration) minute")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
      
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                )
        
    }
   
}

struct HomeView: View {

    let options = [
        MeditationOption(title: "Refresh", duration: 1),
        MeditationOption(title: "Focus", duration: 3),
        MeditationOption(title: "Deep Dive", duration: 5),
        MeditationOption(title: "Power Nap", duration: 10)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.indigo.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Quick Reset")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    
                    Image("Meditation")
                        .resizable()
                        .frame(width: 300, height: 300)
                        

                    Text("Choose your session")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                 
                    ForEach(options) { option in
                        NavigationLink(destination: SoundSelectionView(duration: option.duration)) {
                           
                            SessionButton(option: option)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    HomeView()
}
