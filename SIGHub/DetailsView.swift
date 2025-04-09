import AVKit
import SwiftUI

struct DetailsView: View {
    @State private var hasScrolled = false
    @State private var showVideoOverlay = false
    
    @Binding private var path: NavigationPath

    private var SIG: SIGModel
    private var navtitle: String = "back"

    var body: some View {
//        NavigationStack {
            ZStack(alignment: .topLeading) {
                ScrollView {
                    GeometryReader { proxy in
                        Color.clear
                            .frame(height: 0)
                            .onAppear {
                                hasScrolled =
                                    proxy.frame(in: .global).minY < -100
                            }
                            .onChange(of: proxy.frame(in: .global).minY) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    hasScrolled = proxy.frame(in: .global).minY < -100
                                }
                            }
                            .frame(height: 0)
                    }

                    VStack(spacing: 0) {
                        VideoHeader(showVideoOverlay: $showVideoOverlay)
                            .ignoresSafeArea(.all, edges: .top)

                        ZStack {
                            SIGDetails(SIG: SIG.self)
                                .padding(.top, 80)
                            SIGIcon(SIG: SIG.self)
                                .offset(y: -115)
                        }
                        .background(VisualEffectBlur())

                        ZStack {
                            ArrowLabel(hasScrolled: $hasScrolled)
                                .padding(.top, 10)
                                .padding(.bottom, 32)
                                .background(VisualEffectBlur())
                        }

                        VStack {
                            Description(SIG: SIG.self)
                                .padding(.top, 10)
                            NextEvent(SIG: SIG.self)
                            PastEventView(SIG: SIG.self)
                                .padding(.top, 15)
                            CopyLink()
                                .padding(.top, 40)
                        }
                        .background(
                            GeometryReader { proxy in
                                Color.clear.preference(
                                    key: ScrollOffsetKey.self,
                                    value: proxy.frame(in: .global).minY)
                            })
                    }
                }
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    withAnimation {
                        hasScrolled = value < -100
                    }
                }

//                NavBar(hasScrolled: $hasScrolled)
//                    .position(x: UIScreen.main.bounds.width / 2, y: 0)

                if showVideoOverlay {
                    FullScreenVideo(showVideoOverlay: $showVideoOverlay)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 1.1)), removal: .opacity))
                        .zIndex(2)
                }
            }
//            .toolbarVisibility(.hidden)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            path.removeLast()
                        },
                        label: {
                            if !showVideoOverlay {
                                if hasScrolled {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        HStack {
                                            Image(systemName: "chevron.left")
                                            Text(navtitle)
                                        }
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: "chevron.backward.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .frame(
                                        width: 20, height: 20, alignment: .center
                                    )
                                    .padding(5)
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(50)
                                }
                            }
                    })
                }
            }
//        }

    }

    init(SIG: SIGModel, path: Binding<NavigationPath>) {
        self.SIG = SIG
        self._path = path
    }
    
    init(SIG: SIGModel, path: Binding<NavigationPath>, navtitle: String) {
        self.SIG = SIG
        self._path = path
        self.navtitle = navtitle
    }
}

// MARK: - Scroll Preference Key
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Navigation Bar
struct NavBar: View {
    @Binding var hasScrolled: Bool

    var body: some View {
        ZStack {
            if hasScrolled {
                Color.clear.background(VisualEffectBlur())

                HStack(alignment: .center) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Image("tes2")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, safeAreaTop)
            } else {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.backward.circle.fill")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, safeAreaTop)
            }
        }
        .frame(height: hasScrolled ? 60 : 100)
        .background(
            VisualEffectBlur()
                .opacity(hasScrolled ? 1 : 0)
        )
    }
}

// MARK: - Safe Area
private var safeAreaTop: CGFloat {
    let windowScene = UIApplication.shared
        .connectedScenes
        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene

    return windowScene?.windows.first?.safeAreaInsets.top ?? 0
}

// MARK: - Video Header Thumbnail
struct VideoHeader: View {
    @Binding var showVideoOverlay: Bool

    var body: some View {
        ZStack {
            Image("tes2")
                .resizable()
                .frame(height: UIScreen.main.bounds.width * 6 / 5)
                .clipped()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showVideoOverlay = true
                }
            }) {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
        }
    }
}

// MARK: - Full Screen Video
struct FullScreenVideo: View {
    @Binding var showVideoOverlay: Bool
    @State private var isMuted = false
    @State var url = Bundle.main.url(forResource: "defaultVideo", withExtension: "mp4")!
    
    let player = AVPlayer()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VideoPlayer(player: AVPlayer(url: url))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    player.play()
                    player.isMuted = isMuted
                }
                .onChange(of: isMuted) { newValue in
                    player.isMuted = newValue
                }

            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            player.pause()
                            player.seek(to: .zero)
                            showVideoOverlay = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("TrApple")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)

                Spacer()

                HStack {
                    Image("tes2")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading) {
                        Text("TrApple")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("Travelling")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("What should you prepare for traveling? :eyes::sparkles:")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 80)

                HStack {
                    Spacer()

                    VStack(spacing: 20) {
                        Button(action: {
                            isMuted.toggle()
                            player.isMuted = isMuted
                        }) {
                            Image(
                                systemName: isMuted
                                    ? "speaker.slash.fill"
                                    : "speaker.wave.2.fill"
                            )
                            .font(.title2)
                            .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 80)
                }
            }
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal)
            }
        }
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

// MARK: - SIG Icon
struct SIGIcon: View {
    var SIG: SIGModel

    var body: some View {
        Image(SIG.image)
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
    }
}

// MARK: - SIG Details
struct SIGDetails: View {
    var SIG: SIGModel

    var body: some View {
        VStack(spacing: 5) {
            Button(action: {}) {
                Text(SIG.category)
                    .textCase(.uppercase)
                    .font(.caption)
                    .frame(width: 120, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
            Text(SIG.name)
                .font(.title)
                .bold()

            Text(SIG.realName)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(VisualEffectBlur())
    }
}

// MARK: - Arrow Label
struct ArrowLabel: View {
    @Binding var hasScrolled: Bool
    @State private var isVisible = true

    var body: some View {
        VStack {
            if !hasScrolled {
                Image(systemName: "chevron.compact.down")
                    .font(.title)
                    .foregroundColor(.gray)
                    .opacity(isVisible ? 1 : 0)
                    .animation(
                        .easeInOut(duration: 2).repeatForever(
                            autoreverses: true), value: isVisible)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(
                    Animation.easeInOut(duration: 1).repeatForever(
                        autoreverses: true)
                ) {
                    isVisible.toggle()
                }
            }
        }
    }
}

// MARK: - Description
struct Description: View {
    @State private var isExpanded = false
    var SIG: SIGModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Description")
                    .font(.title2)
                    .bold()
            }

            Text("What is TrApple?")
                .font(.footnote)
                .foregroundColor(.gray)

            HStack(alignment: .bottom) {
                Text(SIG.desc)
                    .font(.callout)
                    .lineLimit(isExpanded ? nil : 3)
                    .animation(.easeInOut, value: isExpanded)

                Button(action: {
                    isExpanded.toggle()
                }) {
                    Text(isExpanded ? "less" : "more")
                        .foregroundColor(.blue)
                        .font(.callout)
                }
            }
        }
        .padding()
    }
}

// MARK: - Next Event
struct NextEvent: View {
    var SIG: SIGModel
    
    var nearestEvents: [EventModel]? {
        let currentDate = Date()
        
        if let events = SIG.events {
            var nearestEvents : [EventModel] = []
            for event in events {
                if event.date > currentDate {
                    nearestEvents.append(event)
                }
            }
            return nearestEvents
        }
        
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Next Event")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            Text("HAPPENING NOW")
                .font(.caption)
                .foregroundColor(.blue)
                .bold()
                .padding(.horizontal)
                .padding(.top, 8)

            ZStack(alignment: .bottomLeading) {
                Image("tes2")
                    .resizable()
                    .resizable()
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), .clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .bottom)
                
                VStack(alignment: .leading) {
                    Text("TANGGAL EVENT")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .bold()
                    
                    Text("Nama Event")
                        .font(.headline)
                        .foregroundColor(.white)
                        .bold()
                    
                    Text("Lokasi Event")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
            

        }
    }
}


// MARK: - Past Event
struct PastEventView: View {
    var SIG: SIGModel
    
    var pastEvents: [EventModel]? {
        let currentDate = Date()
        
        if let events = SIG.events {
            var pastEvents : [EventModel] = []
            for event in events {
                if event.date <= currentDate {
                    pastEvents.append(event)
                }
            }
            return pastEvents
        }
        
        return nil
    }

    @State private var currentIndex = 0

    
    // FIXME: Correct the size of tabview container
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Past Events")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            if let events = pastEvents {
                VStack {
                    TabView(selection: $currentIndex) {
                        ForEach(events.indices, id: \.self) { index in
                            PastEventCard(event: events[index])
                                .tag(index)
                                .padding(.horizontal, 20)
                        }
                    }
                    .frame(height: 110)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    Spacer().frame(height: 16)
                    
                    HStack {
                        ForEach(events.indices, id: \.self) { index in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundColor(
                                    currentIndex == index
                                    ? .blue : .gray.opacity(0.5))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
            } else {
                GroupBox(label: Text("No Event To Show")) {
                    Text("You're up to date! :)")
                }
            }
        }
    }
}

//struct PastEventCard: View {
//    let event: EventModel
//
//    var body: some View {
//        HStack(spacing: 10) {
//            Image(event.image)
//                .resizable()
//                .frame(width: 80, height: 80)
//                .cornerRadius(10)
//                .shadow(radius: 5)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                )
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text(event.name)
//                    .font(.headline)
//
//                Text(event.description)
//                    .font(.callout)
//                    .foregroundColor(.gray)
//
//                Spacer()
//
//                Button(action: {}) {
//                    Text(event.SIG!.category)
//                        .textCase(.uppercase)
//                        .fontWeight(.semibold)
//                        .font(.footnote)
//                        .padding(.vertical, 5)
//                        .padding(.horizontal, 15)
//                        .background(Color.blue.opacity(0.1))
//                        .cornerRadius(5)
//                }
//            }
//            Spacer()
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(15)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
//    }
//}

struct PastEvent {
    let image: String
    let title: String
    let description: String
    let tag: String
}

// MARK: - Group Link
struct CopyLink: View {
    @State private var isCopied = false

    let groupLink = "https://bit.ly"

    var body: some View {
        Button(action: {
            UIPasteboard.general.string = groupLink

            withAnimation(.easeInOut(duration: 2)) {
                isCopied = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 2)) {
                    isCopied = false
                }
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: isCopied ? "checkmark.circle.fill" : "doc.on.doc")
                Text(isCopied ? "Copied!" : "Join Our Community!")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .textCase(.uppercase)
            .fontWeight(.semibold)
            .font(.caption)
            .frame(height: 40)
            .foregroundColor(isCopied ? .white : .green)
            .background(isCopied ? Color.green : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green, lineWidth: 2)
            )
            .cornerRadius(20)
            .transition(.opacity.combined(with: .scale))
        }
        .animation(.easeInOut(duration: 0.3), value: isCopied)
    }
}

// MARK: - Visual Effect Blur
struct VisualEffectBlur: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - Content View Preview
#Preview {
    @Previewable @State var path: NavigationPath = NavigationPath()
    
    DetailsView(SIG: SIGModel.getSample(), path: $path)
}
