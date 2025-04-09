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
                    VideoHeader(path: $path, SIG: SIG)
                        .padding(.top, -20)
                        .ignoresSafeArea(.all, edges: .top)
                    
                    ZStack {
                        ArrowLabel(hasScrolled: $hasScrolled)
                            .padding(.top, 10)
                            .padding(.bottom, 32)
                            .background(VisualEffectBlur())
                    }
                    
                    VStack {
                        Description(SIG: SIG.self)
                            .padding(.top, 15)
                        NextEvent(SIG: SIG.self)
                            .padding(.top, 12)
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
                .ignoresSafeArea()
            }
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                withAnimation {
                    hasScrolled = value < -100
                }
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
                    label: {                            if hasScrolled {
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

// MARK: - Header Thumbnail
struct VideoHeader: View {
//    @Binding var showVideoOverlay: Bool
    @Binding private var path: NavigationPath
    var SIG: SIGModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("Trapple")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 410, height: 510)
                .clipped()
                .overlay(
                    NavigationLink(value: 1){
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 140)
                )

            VStack(spacing: 0) {
                Spacer()
                Image("tes2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(x: 1, y: -1)
                    .frame(height: 270)
                    .clipped()
                    .overlay(
                        VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                            .opacity(1)
                    )
            }
            .frame(height: 140)
            
// MARK: - Blur Overlay + Flipped Image
            VStack(spacing: 0) {
                Image("tes2")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(x: 1, y: -1)
                    .frame(height: 230)
                    .clipped()
                    .overlay(
                        VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                    )
            }
            .frame(height: 140)

            HStack(alignment: .center, spacing: 16) {
                Image(SIG.pp)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                        .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(SIG.category.uppercased())
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())

                    Text(SIG.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    Text(SIG.realName)
                        .font(.body)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .clipShape(Capsule())
                        .foregroundColor(Color.white.opacity(0.7))
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 0))
        .navigationDestination(for: EventModel.self) {event in
            VideoView(path: $path)
        }
    }
    
    init(path: Binding<NavigationPath>, SIG: SIGModel) {
        self._path = path
        self.SIG = SIG
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
        VStack(alignment: .leading, spacing: 0) {
            Text("Next Event")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            if ((nearestEvents?.isEmpty) != nil) {
                Text("UPCOMING EVENT")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 16)

                ZStack(alignment: .bottomLeading) {
                    Image(SIG.image)
                        .resizable()
                        .aspectRatio(16 / 9, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.6), .clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(height: 80)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .padding()
                    
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
            }else {
                GroupBox(label:
                            Text("You're All Set! Check back soon for new events.")
                    .fontWeight(.regular)
                    .foregroundColor(.gray)) {
                }
                .backgroundStyle(Color.white)
//                .padding(.top, -10)
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
                GroupBox(label:
                    Text("You're All Set! Check back soon for new events.")
                    .fontWeight(.regular)
                    .foregroundColor(.gray)) {
                }
                .backgroundStyle(Color.white)
                .padding(.top, -10)
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
    var blurStyle: UIBlurEffect.Style

    init(blurStyle: UIBlurEffect.Style = .systemMaterial) {
        self.blurStyle = blurStyle
    }

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.clipsToBounds = true
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

// MARK: - Content View Preview
#Preview {
    @Previewable @State var path: NavigationPath = NavigationPath()
    
    DetailsView(SIG: SIGModel.getSample(), path: $path)
}
