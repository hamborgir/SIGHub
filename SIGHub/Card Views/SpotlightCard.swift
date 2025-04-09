import SwiftUI
import AVKit

// MARK: - Spotlight Card
struct SpotlightCard: View {
    var event: EventModel
//    var SIG: SIGModel
    var mainColor = Color(red: 190/255, green: 24/255, blue: 32/255)
    
    // TODO: fix spotlightcard size
    var frameMaxWidth: CGFloat = 350
    
    var body: some View {

        VStack() {
            ZStack(alignment: .topLeading) {
                ZStack(alignment: .bottomLeading) {
                    Image(event.SIG!.image)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: frameMaxWidth)
                            
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, .primaryColLight]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 200)
                    .overlay (
                        VStack(alignment: .leading, spacing: 4) {
                            Spacer()
                            Text(event.SIG!.realName)
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
                        }
                        .padding()
                    )
                }
                            
                .overlay(alignment: .topLeading) {
                    HStack {
                        Text("NEXT EVENT")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 0)
                            .background(.primaryCol)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(8)
                    }
                    .background(.primaryCol)
                    .clipShape(RoundedCorners(tl: 0, tr: 0, bl: 0, br: 15))
                }

            }
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
//                    Button(action: {
//                        print("foo")
//                    }) {
//                        Text("Join")
//                            .font(.subheadline).bold()
//                            .frame(width: 60, height: 28)
//                            .background(Color.white.opacity(0.25))
//                            .foregroundColor(.white)
//                            .cornerRadius(14)
//                    }
//                                
//                    Text("Discover More")
//                        .font(.caption2)
//                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
        .background(.primaryCol)
        .frame(width: frameMaxWidth, height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(.primaryCol, lineWidth: 6)
        )
//        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 5)
    }
    
    init(_ Event: EventModel) {
        self.event = Event}
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
