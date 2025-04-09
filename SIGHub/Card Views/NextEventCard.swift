//
//  EventCard.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 08/04/25.
//

import SwiftUI

struct NextEventCard: View {
    var event: EventModel
    
    var gradient = LinearGradient(
        gradient: Gradient(colors: [
            .black.opacity(0.5), .clear,
        ]), startPoint: .bottom, endPoint: .top)
    
    
    var body: some View {
        
        

        ZStack(alignment: .bottomLeading) {
            Image(event.SIG!.image)
                .resizable()
                .aspectRatio(16 / 9, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.9), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(height: 200)
            
            VStack(alignment: .leading) {
                Text(event.formattedDate)
//                        Text(event.formattedDate)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .bold()
                
                Text(event.image+" "+event.name)
//                        Text(event.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
                
                Text(event.description)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                HStack {
//                    Image(systemName: "mappin")
//                        .foregroundStyle(.white)
//                        
                    Text(event.location)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
        }
        .padding(.horizontal, 10)
    }
}

#Preview {

    NextEventCard(event: EventModel.getSample())
//        PastEventCard(event: EventModel.getSample())
    
}
