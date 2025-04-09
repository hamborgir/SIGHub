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
        
            _player = State(initialValue: AVPlayer(url: savedVideoURL))
            print("foo")
        
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    player.allowsExternalPlayback = false
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
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.leading, 40)
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
