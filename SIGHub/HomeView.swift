//
//  HomeView.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var searchText: String = "search..."
    
    var navtitle: String = "Showcase"
    
    
    
    @Environment(\.modelContext) private var context
//    @Query var SIGList: [SIGModel]
    @State var SIGList: [SIGModel] = SIGModel.getData()
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            SpotlightCard(SIGModel.getSample())
                            SpotlightCard(SIGModel.getSample())
                        }
                    }
                    .navigationTitle(navtitle)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .searchable(text: $searchText)
    }
}

#Preview {
    HomeView()
}
