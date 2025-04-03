//
//  HomeView.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    private var navtitle: String = "Home"
    
    @State var SIGList: [SIGModel] = SIGModel.SIGList
    @State var categories: [String]  = getCategory(SIGModel.SIGList)
    @State private var categorizedSIGList: [String: [SIGModel]] = Dictionary(grouping: SIGModel.getData()) { $0.category }
    @State private var path = NavigationPath()
    
    @Environment(\.modelContext) private var context
    
    //    @Query() var SIGList: [SIGModel]
    
    
    
    //    Data khusus untuk bagian searching
    @State private var sessionFilter = ["All", "Morning", "Afternoon"]
    @State private var choosenFilter = "All"
    @State private var searchText: String = ""
    @State private var clickedSearch = false
    @State private var enterSearch = false
    
    // computed properties
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
        NavigationStack(path: $path) {
            VStack {
                
                if (enterSearch) {
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
                    } else {
                        ScrollView {
                            ForEach(filteredSearchedData){ SIG in
                                NavigationLink(value: SIG) {
                                    SIGListObjectView(SIG)
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
                    // Home Page Structure
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            
                            // Spotlight Event
                            SpotlightView(SIGList: $SIGList)
                                .padding(.vertical, 5)
                            
                            
                            // Categorized
                            SIGCategorizedView(categories: $categories, categorizedSIGList: $categorizedSIGList)
                        }
                    }
                }
                
            }
            .searchable(text: $searchText, isPresented: $clickedSearch)
            .searchSuggestions{
                if(!searchText.isEmpty){
                    ForEach(searchedData){ SIG in
                        suggestionView(SIG: SIG)
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
            .navigationTitle(navtitle)
            .navigationDestination(for: SIGModel.self) { SIG in
                // For spotlight and SIGcards
                Image(SIG.image)
                    .resizable()
                    .frame(width: 300, height: 200)
                Text(SIG.name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(SIG.realName)
            }
            .navigationDestination(for: String.self) {category in
                // For SIGCategorized title
                
                SIGListView(SIGList: categorizedSIGList[category] ?? [], category: category)
                
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
                    NavigationLink(value: SIG) {
                        SpotlightCard(SIG)
                    }
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
    @State var SIG: SIGModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            Text(SIG.name)
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
        }
        .searchCompletion(SIG.name)
        .listRowSeparator(.hidden)
    }
}

struct SIGCategorizedView: View {
    @Binding var categories: [String]
    @Binding var categorizedSIGList: [String: [SIGModel]]
    
    var body: some View {
        ForEach(categories, id:\.self) { category in
            Group {
                NavigationLink(value: category) {
                    HStack {
                        Text(category)
                            .font(.title.bold())
                            .foregroundColor(.black)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .padding(.leading, 0)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 5)
            .padding(.bottom, 0)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    let filteredSIG = categorizedSIGList[category] ?? []
                    ForEach(filteredSIG, id:\.id) { SIG in
                        NavigationLink(value: SIG) {
                            SIGCard(SIG)
                        }
                    }
                }
            }
        }
    }
}
