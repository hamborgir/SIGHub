import SwiftUI
import AVKit

struct PlayerUIView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        return PlayerView(player: player)
//        let view = UIView()
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(playerLayer)
//        context.coordinator.playerLayer = playerLayer
//        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
//        context.coordinator.playerLayer?.frame = uiView.bounds
    }

    class PlayerView: UIView {
        private var playerLayer = AVPlayerLayer()
        
        init(player: AVPlayer) {
            super.init(frame: .zero)
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspect
            layer.addSublayer(playerLayer)
        }
        
        required init?(coder: NSCoder) {
            fatalError( "init(coder:) has not been implemented" )
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer.frame = bounds
        }
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    class Coordinator {
//        var playerLayer: AVPlayerLayer?
//    }
}
