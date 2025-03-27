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
    @State var SIGList: [SIGModel] = SIGModel.SIGList
    @State var categories: [String]  = getCategory(SIGModel.SIGList)
    
    @Environment(\.modelContext) private var context
    
    //    @Query() var SIGList: [SIGModel]
    
    var navtitle: String = "Showcase"
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    // Spotlight Section
                    SpotlightView(SIGList: $SIGList)
                    
                    // Category Section
                    //                    ForEach(categories, id:\.self) { category in
                    //                        Text(category)
                    //                    }
                    ForEach(categories, id:\.self) { category in
                        Group {
                            Color.red
                            
                        }
                    }
                }
                
                
            }
            .navigationTitle(navtitle)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .searchable(text: $searchText)
    }
    
    static func getCategory(_ SIGList: [SIGModel]) -> [String] {
        var categories: [String] = []
        for SIG in SIGList {
            categories.append(SIG.category)
        }
        
        return Array(Set(categories))
    }
}

#Preview {
    HomeView()
}

struct SpotlightView: View {
    @Binding var SIGList: [SIGModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(SIGList) { SIG in
                    SpotlightCard(SIG)
                }
            }
        }
    }
}
