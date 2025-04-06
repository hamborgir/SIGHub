//
//  Cards.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 27/03/25.
//

import SwiftUI

struct SIGCard: View {
    var SIG: SIGModel
    
    var width: CGFloat = 130
    var height: CGFloat = 130
    
    var body: some View {
        VStack {
            // Image
            // ganti image nanti
            Image(SIG.image)
                .resizable()
                .frame(width: self.width, height: self.height*(6/10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 10)
                .scaledToFit()
            
            // SIG property
            Group {
                Text(SIG.category.uppercased())
                    .font(.caption)
                    .foregroundColor(.gray).bold()
                Text(SIG.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(SIG.session)
                    .font(.caption2)
                    .foregroundColor(.black)
            }
            .frame(maxWidth:.infinity, alignment: .topLeading)
            
        }.frame(width: self.width, height: .infinity)
    }
    
    init() {
        self.SIG = SIGModel.getSample()
    }
    
    init(_ SIG: SIGModel) {
        self.SIG = SIG
    }
}

#Preview {
    SIGCard()
}
