import SwiftUI
import AVKit

// MARK: - Spotlight Card
struct SpotlightCard: View {
    var Event: EventModel
//    var SIG: SIGModel
    
    var body: some View {
//        VStack {
//            ZStack {
//                Image(Event.SIG!.image)
//                    .resizable()
//                    .frame(maxWidth: .infinity, maxHeight: 350)
//
//                Rectangle()
//                    .fill(.black.opacity(0.5))
//                    .frame(maxWidth: .infinity, maxHeight: 350)
//
//
//                VStack (alignment: .leading){
//                    Text("Upcoming Events")
//                        .foregroundColor(.white.opacity(0.9))
//
//                    Text(Event.name)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .padding(.bottom, 4)
//
//                    HStack {
//                        Image(systemName: "clock")
//                        Text(Event.formattedDate)
//                    }
//
//                    HStack {
//                        Image(systemName: "location")
//                        Text(Event.location)
//                    }
//                }
//                .padding(.leading, 25)
//                .padding(.bottom, 85)
//                .foregroundColor(.white)
//                .frame(width: 350, height: 350, alignment: .bottomLeading)
//
////                .background(.blue)
//
//                VStack{
//                    HStack {
//                        Image(Event.SIG!.pp)
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .cornerRadius(20)
//
//                        Text (Event.SIGName)
//                            .font(.title3)
//                            .fontWeight(.bold)
//
//                    }
//                    .padding([.bottom, .leading], 20)
//                    .padding([.top, .trailing], 10)
//                    .background(.color)
//                    .cornerRadius(20)
//                    .foregroundColor(.white)
//
//                }
//                .frame(maxWidth: .infinity, maxHeight: 350, alignment: .bottomLeading)
//
//            }
//            .overlay(
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(.color, lineWidth: 30)
//            )
//            .cornerRadius(20)
//        }
//    }
        
        VStack() {
            ZStack(alignment: .topLeading) {
                ZStack(alignment: .bottomLeading) {
                    Image(Event.SIG!.image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 370, maxHeight: .infinity)
                        .clipped()
                            
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color(red: 190/255, green: 24/255, blue: 32/255)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 200)
                                
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TRAVELING")
                            .font(.subheadline).bold()
                            .foregroundColor(.white.opacity(0.8))
                                    
                        Text("Travel with TrApple")
                            .font(.title).bold()
                            .foregroundColor(.white)
                                
                        Text("Where’s Next? Let TrApple Guide You!")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
                .frame(maxHeight: .infinity)
                            
                .overlay(alignment: .topLeading) {
                    HStack {
                        Text("NEXT EVENT")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 0)
                            .background(Color(red: 160/255, green: 24/255, blue: 32/255))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(8)
                    }
                    .background(Color(red: 160/255, green: 24/255, blue: 32/255))
                    .clipShape(RoundedCorners(tl: 0, tr: 0, bl: 0, br: 15))
                }
                .frame(maxHeight: .infinity)

            }
            HStack {
                Image(Event.SIG!.pp)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                            
                VStack(alignment: .leading, spacing: 2) {
                    Text(Event.formattedDate)
                        .font(.callout.bold())
                        .foregroundColor(.white)
                                
                    Text(Event.location)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                }
                            
                Spacer()
                            
                VStack(spacing: 4) {
                    Button(action: {}) {
                        Text("View")
                            .font(.subheadline).bold()
                            .frame(width: 60, height: 28)
                            .background(Color.white.opacity(0.25))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                                
                    Text("Discover More")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 10)
                        
            Spacer()
        }
        .frame(height: 500)
        .background(Color(red: 160/255, green: 24/255, blue: 32/255))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(Color(red: 160/255, green: 24/255, blue: 32/255), lineWidth: 6)
        )
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 5)
    }
    
    init(_ Event: EventModel) {
        self.Event = Event}
}

// MARK: - Rounder Corner Bottom Right "Next Event"
struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.closeSubpath()

        return path
    }
}

#Preview {
    SpotlightCard(EventModel.getSample())
}
