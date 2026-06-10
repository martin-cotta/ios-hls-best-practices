import SwiftUI
import AVKit

struct ContentView: View {
    @ObservableObject private var hlsViewModel = HLSViewModel()

    var body: some View {
        VStack {
            if let player = hlsViewModel.player {
                VideoPlayer(player: player)
                    .onAppear {
                        hlsViewModel.startPlayback()
                    }
                    .onDisappear {
                        hlsViewModel.stopPlayback()
                    }
            } else if let errorMessage = hlsViewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Loading Stream...")
            }
        }
        .onAppear {
            Task {
                await hlsViewModel.loadStream(urlString: "https://example.com/stream/playlist.m3u8")
            }
        }
    }
}

@Observable class HLSViewModel {
    var player: AVPlayer?
    var errorMessage: String?

    func loadStream(urlString: String) async {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        do {
            // Simulate network check or preloading metadata (Async example)
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            
            self.player = AVPlayer(url: url)
        } catch {
            self.errorMessage = "Failed to load the stream."
        }
    }

    func startPlayback() {
        player?.play()
    }

    func stopPlayback() {
        player?.pause()
    }
}