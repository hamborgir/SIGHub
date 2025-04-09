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
                .aspectRatio(contentMode: .fill)
                .frame(width: 95, height: 70)
                .cornerRadius(10)
            
            VStack (alignment: .leading) {
                
                
                Text(SIG.name)
                    .font(.headline)
                    .padding(.bottom, -2)
                
                HStack {
                    Text(SIG.session)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(.primaryCol)
                        .cornerRadius(5)
                    
                    Text(SIG.category)
                        .font(.caption2)
                        .foregroundColor(.primaryCol)
                        .padding(5)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.primaryCol, lineWidth: 1)
                        )
                        
                }
                
                
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
