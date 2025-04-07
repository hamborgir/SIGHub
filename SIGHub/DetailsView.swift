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
                                newValue in
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    hasScrolled = newValue < -100
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
                            SIGIcon(imageName: SIG.pp)
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
                            Preview(SIG: SIG.self)
                            NextEvent(SIG: SIG)
                            PastEventView(SIG: SIG)
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
                        .transition(.opacity.combined(with: .scale))
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
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
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
                VisualEffectBlur()
                    .opacity(hasScrolled ? 1 : 0)

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
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?
        .safeAreaInsets.top ?? 0
}

// MARK: - Video Header Thumbnail
struct VideoHeader: View {
    @Binding var showVideoOverlay: Bool

    var body: some View {
        ZStack {
            Image("tes2")
                .resizable()
                .frame(height: UIScreen.main.bounds.width * 4 / 3)
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

// MARK: - Full Screen Video Overlay
struct FullScreenVideo: View {
    @Binding var showVideoOverlay: Bool
    @State private var isMuted = false
    @State var url = Bundle.main.url(forResource: "Create Animated Videos in After Effects", withExtension: "mp4")!
    
    let player = AVPlayer(
        url: URL(string: "https://www.w3schools.com/html/mov_bbb.mp4")!)

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
                        Text("What should you prepare for traveling? 👀✨")
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

// MARK: - Video Progress Bar
struct VideoProgressBar: View {
    @Binding var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 4)
                    .opacity(0.3)
                    .foregroundColor(.white)

                Rectangle()
                    .frame(width: geometry.size.width * progress, height: 4)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - SIG Icon
struct SIGIcon: View {
    var imageName: String
    var body: some View {
        Image(imageName)
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
                    .cornerRadius(20)
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
                        .easeInOut(duration: 1).repeatForever(
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

// MARK: - Preview
struct Preview: View {
    @State private var isExpanded = false
    var SIG: SIGModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Preview")
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
            }

            Text("What is TrApple?")
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack(alignment: .bottom) {
                Text(SIG.desc)
                    .font(.body)
                    .lineLimit(isExpanded ? nil : 3)
                    .animation(.easeInOut, value: isExpanded)

                Button(action: {
                    isExpanded.toggle()
                }) {
                    Text(isExpanded ? "less" : "more")
                        .foregroundColor(.blue)
                        .font(.body)
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

            if let events = nearestEvents {
                // FIXME: Change the UX Writing for this
                Text("HAPPENING NOW")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .bold()
                    .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(events, id: \.id) { event in
                            NextEventCard(event: event)
                        }
                    }
                }
            } else {
                GroupBox(label: Text("No Event To Show")) {
                    Text("You're up to date! :)")
                }
            }
            

        }
    }
}


// MARK: - Past Event
struct PastEventView: View {
    private var SIG: SIGModel
    
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
    
    init(SIG: SIGModel) {
        self.SIG = SIG
    }
}

struct PastEvent {
    let image: String
    let title: String
    let description: String
    let tag: String
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
