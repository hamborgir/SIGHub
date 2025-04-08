//
//  SpotlightCard.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import SwiftUI

struct SpotlightCard: View {
    var Event: EventModel
    
    var body: some View {
        VStack {
            ZStack {
                Image(Event.SIG!.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 350, maxHeight: 350)
                
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: 350)
                    
                
                VStack (alignment: .leading){
                    Text("Upcoming Events")
                        .foregroundColor(.white.opacity(0.9))
                        
                    Text(Event.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)
                    
                    HStack {
                        Image(systemName: "clock")
                        Text(Event.formattedDate)
                    }
                    
                    HStack {
                        Image(systemName: "location")
                        Text(Event.location)
                    }
                }
                .padding(.leading, 25)
                .padding(.bottom, 85)
                .foregroundColor(.white)
                .frame(width: 350, height: 350, alignment: .bottomLeading)
                
//                .background(.blue)
                
                VStack{
                    HStack {
                        Image(Event.SIG!.pp)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                        
                        Text (Event.SIGName)
                            .font(.title3)
                            .fontWeight(.bold)
                            
                    }
                    .padding([.bottom, .leading], 20)
                    .padding([.top, .trailing], 10)
                    .background(.color)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 350, alignment: .bottomLeading)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.color, lineWidth: 30)
            )
            .cornerRadius(20)
        }
        .frame(width: .infinity, height: 350)
    }
    
    init(_ Event: EventModel) {
        self.Event = Event}
}

#Preview {
    SpotlightCard(EventModel.getSample())
}
