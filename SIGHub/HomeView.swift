//
//  HomeView.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State var SIGList: [SIGModel] = SIGModel.SIGList
    @State var categories: [String]  = getCategory(SIGModel.SIGList)
    
    @Environment(\.modelContext) private var context
    
    //    @Query() var SIGList: [SIGModel]
    
    var navtitle: String = "Showcase"
    
    
//    Data khusus untuk bagian searching
    @State private var sessionFilter = ["All", "Morning", "Afternoon"]
    @State private var choosenFilter = "All"
    @State private var searchText: String = ""
    @State private var clickedSearch = false
    @State private var enterSearch = false
    
    var filteredSearchedData: [SIGModel] {
        SIGList
            .filter {
                (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) || $0.realName.localizedCaseInsensitiveContains(searchText))}
            .filter {
                (choosenFilter == "All" || $0.session.contains(choosenFilter))
            }
    }
    
    var searchedData: [SIGModel] {
        SIGList
            .filter {
                (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText))}
    }
    
    
    var body: some View {
        NavigationStack {
                VStack {
                    
                    if(enterSearch){
//                        Search Page
                        
                        Picker("Filter", selection: $choosenFilter){
                            ForEach (sessionFilter, id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding([.leading, .trailing], 15)
                        
                        if filteredSearchedData.isEmpty {
                            noResultView()
                        }else {
                            ScrollView {
                                ForEach(filteredSearchedData){ sig in
                                    NavigationLink(destination: ContentView()){
                                        SearchObjectList(SIGPict: sig.image, SIGName: sig.name, SIGDescription: sig.desc, SIGCategory: sig.category)
                                            .listRowInsets(EdgeInsets())
                                            .listRowSeparator(.hidden)
                                    }
                                    
                                }
                            }
                            .padding(.top, 10)
                        }
                        Spacer()
                    }
                    else {
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
                    }
                    
                }
                .searchable(text: $searchText, isPresented: $clickedSearch)
                .searchSuggestions{
                    if(!searchText.isEmpty){
                        ForEach(searchedData){ sig in
                            suggestionView(sig: sig)
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .onSubmit (of: .search) {
                    enterSearch = true
                }
                .onChange(of: searchText) {
                    if searchText.isEmpty {
                        enterSearch = false
                    }
                }
                Spacer()
        }
        .padding(.horizontal, 10)
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

//View untuk home
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

//View untuk search
struct noResultView: View {
    
    var body: some View {
        Text("No Result")
            .foregroundColor(.gray)
            .padding(.top, 30)
    }
}

struct suggestionView: View {
    @State var sig: SIGModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            Text(sig.name)
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
        }
        .searchCompletion(sig.name)
        .listRowSeparator(.hidden)
    }
}
