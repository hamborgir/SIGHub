//
//  VideoFullScreen.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 09/04/25.
//

import SwiftUI
import AVKit

// MARK: - Full Screen Video
import AVKit
import SwiftUI

struct VideoFullScreen: View {
    @State private var player = AVPlayer()
    @State private var isFullscreen = true
    @Binding var showVideoOverlay: Bool

    init(showVideoOverlay: Binding<Bool>) {
        _showVideoOverlay = showVideoOverlay
        
        let fileManager = FileManager.default
        let documentDirectoryURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let savedVideoURL = documentDirectoryURL.appendingPathComponent("defaultVideo.mp4")
        
        if fileManager.fileExists(atPath: savedVideoURL.path) {
            _player = State(initialValue: AVPlayer(url: savedVideoURL))
        } else {
            _player = State(initialValue: AVPlayer(url: Bundle.main.url(forResource: "defaultVideo", withExtension: "mp4")!))
        }
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    player.play()
                }

            if isFullscreen {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isFullscreen = false
                                showVideoOverlay = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .padding()
                        }

                        Spacer()
                    }
                    Spacer()
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isFullscreen)
    }
}

#Preview {
    @Previewable @State var showVideoOverlay: Bool = true
    VideoFullScreen(showVideoOverlay: $showVideoOverlay)
}
