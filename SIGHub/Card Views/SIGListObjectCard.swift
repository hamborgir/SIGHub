//
//  SearchObjectList.swift
//  SIGHub
//
//  Created by Ethelind Septiani Metta on 27/03/25.
//

import SwiftUI

struct SIGListObjectView: View {
    var SIG: SIGModel
    
    var SIGPict: String = ""
    var SIGName: String = ""
    var SIGDescription: String = ""
    var SIGCategory: String = ""
    
    var body: some View {
        HStack {
            Image(SIG.image)
                .resizable()
                .frame(width: 90, height: 65)
                .cornerRadius(10)
            
            VStack (alignment: .leading) {
                
                Text(SIG.category)
                    .font(.caption2)
                    .foregroundColor(.pink)
                Text(SIG.name)
                    .font(.headline)
                
                Text(SIG.desc)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 270)
        }
        .padding([.bottom, .top], 10)
        .frame(width: 400)
        .foregroundColor(.black)
        }
    
    init(_ SIG: SIGModel) {
        self.SIG = SIG
    }
    
    init() {
        self.SIG = SIGModel.getSample()
    }
}

#Preview {
    SIGListObjectView()
}
