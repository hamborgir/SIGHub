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
        
        ZStack {
            Image(event.SIG!.image)
                .resizable()
                .aspectRatio(9 / 16, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading) {
                Text(event.formattedDate)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .bold()
                
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
                
                // TODO: Add location data in Event Model
                Text("Lokasi Event")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(gradient)
        }
        .padding(.horizontal)
        .frame(width: 200, height: 200)
    }
}

#Preview {

    NextEventCard(event: EventModel.getSample())
//        PastEventCard(event: EventModel.getSample())
    
}
