import AVKit
import SwiftUI

struct DetailsView: View {
    @State private var hasScrolled = false
    @State private var showVideoOverlay = false
    @State private var selectedEvent: EventModel? = nil
    @Binding private var path: NavigationPath
    @State private var showEventPopup = false

    
    private var SIG: SIGModel
    private var navtitle: String = "back"
        
    var body: some View {
        //        NavigationStack {
        ZStack(alignment: .topLeading) {
            ScrollView(showsIndicators: false) {
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
                    VideoHeader(path: $path, SIG: SIG, hasScrolled: hasScrolled)
                        .padding(.top, -20)
                    
                    VStack {
                        Description(SIG: SIG.self)
                            .padding(.top, 15)
                        NextEvent(SIG: SIG, showEventPopup: $showEventPopup, selectedEvent: $selectedEvent)
                            .padding(.top, 10)
                        PastEventView(SIG: SIG.self)
                            .padding(.top, 25)
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        path.removeLast()
                    },
                    label: {
                        if hasScrolled {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text(navtitle)
                                }
                            }
                        } else {
                            HStack {
                                Image(systemName: "chevron.backward.circle")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            .frame(
                                width: 20, height: 20, alignment: .center
                            )
                            .padding(5)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(50)
                        }
                    })
                    }
            }
        .overlay(
            Group {
                if showEventPopup, let event = selectedEvent {
                    popup(event: event, isVisible: $showEventPopup)
                        .zIndex(3)
                }
            }
        )
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
    @State var hasScrolled: Bool
    @Binding private var path: NavigationPath
    var SIG: SIGModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("Cover")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 410, height: 760)
                .overlay(
                    NavigationLink(value: 1){
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.top, -50)
                    }
                        .padding(.bottom, 200)
                )
            
            ZStack(alignment: .bottom) {
                Image("tes2")
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fit)
                    .scaleEffect(x: 1, y: -1)
                    .frame(height: 300)
                    .clipped()
                    .overlay(
                        VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                            .opacity(1)
                    )
                
// MARK: - Blur Overlay + Flipped Image
                VStack(spacing: 4) {
                    Image(SIG.pp)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .shadow(radius: 5)
                        .padding(.bottom, 25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                        )
                    
                    Text(SIG.category.uppercased())
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.bottom, 8)
                        
                    Text(SIG.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        
                    Text(SIG.realName)
                        .font(.body)
                        .clipShape(Capsule())
                        .padding(.bottom, 20)
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Button(action: {
                        if let url = URL(string: "https://iosda.link/SIGCommunity") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Join the Club")
                            .font(.callout.weight(.semibold))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 38)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(radius: 5)
                    }
                    
                    ArrowLabel(hasScrolled: $hasScrolled)
                        .padding(.top, 12)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
                .offset(y: 10)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 0))
        .ignoresSafeArea(.all, edges: .top)
    }
    
    init(path: Binding<NavigationPath>, SIG: SIGModel, hasScrolled: Bool) {
        self._path = path
        self.SIG = SIG
        self.hasScrolled = hasScrolled
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
                    .foregroundColor(Color.white.opacity(0.7))
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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Description")
                    .font(.title2)
                    .bold()
            }
            
            Text("What is TrApple?")
                .font(.callout)
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
//    var event: EventModel
    @Binding var showEventPopup: Bool
    @Binding var selectedEvent: EventModel?
    
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
                Text("SAVE YOUR SPOT")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 8)

                ZStack(alignment: .bottomLeading) {
                    Image("tes2")
//                    Image(event.SIG!.pp)
                        .resizable()
                        .aspectRatio(16 / 9, contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.6), .clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(height: 200)
                    
                    VStack(alignment: .leading) {
                        Text("event.formattedDate")
//                        Text(event.formattedDate)
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                            .bold()
                        
                        Text("event.name")
//                        Text(event.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .bold()
                        
                        Text("event.location")
//                        Text(event.location)
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
                .frame(height: 200)
                .padding(.horizontal)
                .onTapGesture {
                    if let firstEvent = nearestEvents?.first {
                        selectedEvent = firstEvent
                        withAnimation(.easeInOut) {
                            showEventPopup = true
                        }
                    }
                }
                
            }else {
                GroupBox(label:
                            Text("You're All Set! Check back soon for new events.")
                    .fontWeight(.regular)
                    .foregroundColor(.gray)) {
                }
                .backgroundStyle(Color.white)
            }
        }
    }
}

// MARK: - Next Event Pop Up
struct popup: View {
    var event: EventModel
    @Binding var isVisible: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isVisible = false
                    }
                }

            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    ZStack(alignment: .topLeading) {
                        Image("tes2")
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }

                    Button {
                        withAnimation(.easeInOut) {
                            isVisible = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3.bold())
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(12)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(event.SIG!.realName.uppercased())
                        .font(.subheadline).bold()
                        .foregroundColor(.white.opacity(0.8))
                                
                    Text(event.name)
                        .font(.title).bold()
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Text(event.description)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                    
                    Divider()
                        .padding(.vertical, 6)
                        .foregroundColor(.white)

                    HStack {
                        Image(event.SIG!.pp)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                                    
                        VStack(alignment: .leading, spacing: 2) {
                            Text(event.formattedDate)
                                .font(.callout.bold())
                                .foregroundColor(.white)
                                        
                            Text(event.location)
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.8))
                        }
                                    
                        Spacer()
                                    
                        VStack(spacing: 4) {
                            Image(systemName: event.SIG!.shiftIcon)
                                .foregroundColor(.white)
                                .frame(height: .infinity)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .padding()
            .frame(maxWidth: 500)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

// MARK: - Past Event
struct PastEventView: View {
    var SIG: SIGModel
//    var event: EventModel
    
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
                                .padding(.bottom, 15)
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

struct PastEvent {
    let image: String
    let title: String
    let description: String
    let tag: String
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
