//
//  SpotlightCard.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import SwiftUI

struct SpotlightCard: View {
    var SIG: SIGModel
    var body: some View {
        ZStack {
            // ini nanti ganti image
            Color(.yellow)
            Text("🤣")
//                .frame(width: 300, height: 400)
                .font(.system(size:200))
            
            Color(.black)
                .opacity(0.3)
//                .frame(width: 300, height: 400)
        }
        .overlay {
            VStack(alignment: .leading) {
                Spacer()
                Text(" "+SIG.realName+" ")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .background(.white)
                    .clipShape(Capsule())
                
                
                Text(SIG.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Label("Some event", systemImage: "mappin")
                    .foregroundColor(.white)
                    .italic()
                
                Label("12:00 29/03/2025", systemImage: "calendar")
                    .foregroundColor(.white)
                
                Label("Hiking", systemImage: "figure.run")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
        }
        .frame(width: 300, height: 400)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
    }
    
    init(_ SIG: SIGModel) {
        self.SIG = SIG
    }
}

#Preview {
    SpotlightCard(SIGModel.getSample())
}
