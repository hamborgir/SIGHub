//
//  Cards.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 27/03/25.
//

import SwiftUI

struct SIGCard: View {
    var SIG: SIGModel
    
    var width: CGFloat = 200
    var height: CGFloat = 200
    
    var body: some View {
        VStack {
            // Image
            // ganti image nanti
            ZStack {
                Color.blue
                Text("😍").font(.system(size: 100))
            }
            .frame(width: self.width, height: self.height*(6/10))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom, 10)
            
            // SIG property
            Group {
                Text(SIG.category.uppercased()).font(.caption).foregroundColor(.gray).bold()
                Text(SIG.name).font(.headline)
                Text(SIG.session).font(.caption2)
            }
            .frame(maxWidth:.infinity, alignment: .leading)
            
        }.frame(width: self.width, height: self.height)
    }
    
    init() {
        self.SIG = SIGModel.getSample()
    }
}

#Preview {
    SIGCard()
}
