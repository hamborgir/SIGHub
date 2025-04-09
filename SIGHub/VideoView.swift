//
//  VideoView.swift
//  SIGHub
//
//  Created by Ethelind Septiani Metta on 09/04/25.
//

import SwiftUI
import AVKit

struct VideoView: View {
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "defaultVideo", withExtension: "mp4")!)
    
    @State private var showControls = false
    @State private var isPlaying = false
    @State private var isMuted = false
    @State private var isEditing = false
    @State private var animateButton = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 1
    
    @Binding private var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                PlayerUIView(player: player)
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showControls.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {                            withAnimation(.easeInOut) {
                            showControls = false
                        }
                        }
                    }
            }
            .onAppear {
                let fileManager = FileManager.default
                                let documentDirectoryURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                let savedVideoURL = documentDirectoryURL.appendingPathComponent("defaultVideo.mp4")
                                
                                if fileManager.fileExists(atPath: savedVideoURL.path) {
                                            player = AVPlayer(url: savedVideoURL)
                                        } else {
                                            player = AVPlayer(url: Bundle.main.url(forResource: "defaultVideo", withExtension: "mp4")!)
                                        }
                                
                
                player.play()
                isPlaying = true
                
                player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
                    currentTime = time.seconds
                    duration = player.currentItem?.duration.seconds ?? 1
                    
                    if currentTime >= duration {
                        withAnimation(.easeInOut) {
                            path.removeLast()
                            isPlaying = false
                        }
                    }
                }
            }
            
            // MARK: - Play and Pause Button (Full Screen Video)
            if showControls {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack {
                    Spacer()
                    HStack(spacing: 50) {
                        Button { seek(by: -10) } label: {
                            rewindForwardIcon(systemName: "gobackward.10")
                        }
                        
                        Button {
                            togglePlay()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                animateButton = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                animateButton = false
                            }
                        } label: {
                            ZStack {
                                if isPlaying {
                                    Image(systemName: "pause.fill")
                                        .transition(.scale.combined(with: .opacity))
                                } else {
                                    Image(systemName: "play.fill")
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .font(.system(size: 45))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                            .scaleEffect(animateButton ? 1.2 : 1.0)
                        }
                        .animation(.easeInOut(duration: 0.3), value: isPlaying)
                        
                        Button { seek(by: 10) } label: {
                            rewindForwardIcon(systemName: "goforward.10")
                        }
                    }
                    Spacer()
                }
                .transition(.opacity)
            }
            
            VStack {
                // MARK: - Navigation Bar (Full Screen Video)
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
//                            player.pause()
                            path.removeLast()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("TrApple")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        isMuted.toggle()
                        player.isMuted = isMuted
                    }) {
                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                    }
                }
                Spacer()
            }
            
            // MARK: - Progress Bar (Full Screen Video)
            VStack {
                Spacer()
                ProgressBar(
                    currentTime: $currentTime,
                    duration: duration,
                    isEditing: $isEditing
                ) { newTime in
                    player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
                }
                .padding(.bottom, 20)
            }
        }
        .animation(.easeInOut, value: showControls)
    }
    
    func togglePlay() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func seek(by seconds: Double) {
        let newTime = currentTime + seconds
        player.seek(to: CMTime(seconds: max(0, min(duration, newTime)), preferredTimescale: 600))
    }
    
    func rewindForwardIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 28))
            .foregroundColor(.white)
            .shadow(radius: 5)
    }
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
}

// MARK: - Progress Bar
struct ProgressBar: View {
    @Binding var currentTime: Double
    var duration: Double
    @Binding var isEditing: Bool
    var onSeek: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Slider(value: $currentTime, range: 0...duration, isEditing: $isEditing) { editing in
                isEditing = editing
                if !editing {
                    onSeek(currentTime)
                }
            }
            
            HStack {
                Text(formatTime(currentTime))
                Spacer()
                Text("-\(formatTime(duration - currentTime))")
            }
            .font(.caption)
            .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 10)
    }
    
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Progress Bar Slider
struct Slider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    @Binding var isEditing: Bool
    var onEditingChanged: (Bool) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let progress = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: isEditing ? 6 : 3)
                
                Capsule()
                    .fill(Color.white)
                    .frame(width: width * progress, height: isEditing ? 6 : 3)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: isEditing ? 18 : 12, height: isEditing ? 18 : 12)
                    .offset(x: max(0, min(width - 10, width * progress - (isEditing ? 9 : 6))))
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        isEditing = true
                        let location = gesture.location.x
                        let newValue = Double(location / width) * (range.upperBound - range.lowerBound) + range.lowerBound
                        value = min(max(range.lowerBound, newValue), range.upperBound)
                        onEditingChanged(true)
                    }
                    .onEnded { _ in
                        isEditing = false
                        onEditingChanged(false)
                    }
            )
        }
        .frame(height: 20)
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = NavigationPath()
    VideoView(path: $path)
}
