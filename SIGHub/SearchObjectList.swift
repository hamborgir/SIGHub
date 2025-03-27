//
//  SearchObjectList.swift
//  SIGHub
//
//  Created by Ethelind Septiani Metta on 27/03/25.
//

import SwiftUI

struct SearchObjectList: View {
    @State var SIGPict: String = ""
    @State var SIGName: String = ""
    @State var SIGDescription: String = ""
    @State var SIGCategory: String = ""
    
    var body: some View {
        HStack {
            Image(SIGPict)
                .resizable()
                .frame(width: 90, height: 65)
                .cornerRadius(10)
            
            VStack (alignment: .leading) {
                
                Text(SIGCategory)
                    .font(.caption2)
                    .foregroundColor(.pink)
                Text(SIGName)
                    .font(.headline)
                
                Text(SIGDescription)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 250)
        }
        .padding([.bottom, .top], 10)
        .frame(width: 350)
        .foregroundColor(.black)
        }
}

#Preview {
    SearchObjectList()
}
