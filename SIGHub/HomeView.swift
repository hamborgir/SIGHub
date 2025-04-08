//
//  HomeView.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var navtitle: String = "Home" //nanti ganti (jangan home)
    @State private var path = NavigationPath()
    
    @State var SIGList: [SIGModel] = SIGModel.SIGList
    @State var categories: [String]  = getCategory(SIGModel.SIGList)
    @State private var categorizedSIGList: [String: [SIGModel]] = Dictionary(grouping: SIGModel.getData()) { $0.category }
    
    //    @Query() var SIGList: [SIGModel]
    
    
    
    //    Data khusus untuk bagian searching
    @State private var sessionFilter = ["All", "Morning", "Afternoon"]
    @State private var choosenFilter = "All"
    @State private var searchText: String = ""
    @State private var clickedSearch = false
    @State private var enterSearch = false
    
    let backgroundGradient = LinearGradient(
        colors: [Color.red, Color.blue],
        startPoint: .top, endPoint: .bottom)
    
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
    
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            // TODO: Implement color gradient
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
                                    VStack {
                                        
                                        SIGListObjectView(SIG)
                                            .listRowInsets(EdgeInsets())
                                        Divider()
                                                .frame(width: 300)
                                    }
                                    
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
                        VStack (alignment: .leading){
                            
                            VStack (alignment: .leading){
                                HStack {
                                    Image(systemName: "hand.wave.fill")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 25))
                                    Text("Hi,")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                .padding(.top, 10)
                                
                                Text("Explore more about SIG in ADA")
                                    .font(.title3)
                                    
                            }
                            
                            // Spotlight Event
                            SpotlightView()
                                .padding(.vertical, 5)
                            
                            
                            // Categorized
                            SIGCategorizedView(categories: $categories, categorizedSIGList: $categorizedSIGList)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
            }
            .searchable(text: $searchText, isPresented: $clickedSearch, placement: .navigationBarDrawer(displayMode: .always))
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
                navtitle = "Search"
            }
            .onChange(of: searchText) {
                if searchText.isEmpty {
                    enterSearch = false
                    navtitle = "Home"
                }
            }
//            .navigationTitle(navtitle)
//            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: SIGModel.self) { SIG in
                //                 For spotlight and SIGcards
                
                DetailsView(SIG: SIG, path: $path, navtitle: navtitle)
            }
            .navigationDestination(for: String.self) {category in
                // Categorized SIG List
                
                SIGListView(SIGList: categorizedSIGList[category] ?? [])
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(category)
                                .bold()
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            Spacer()
        }
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

//MARK: - Spotlight View
struct SpotlightView: View {
    private var eventList: [EventModel] = EventModel.eventList
    private var isNearestEventAvailable: Bool { !nearestEventList.isEmpty }
    
    private var nearestEventList: [EventModel] {
        let N : Int = 7 // days to consider
        
        var eventWithinNDays: [EventModel] = []
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let lowerDate: Date = Date()
        let upperDate: Date = calendar.date(byAdding: .day, value: N, to: lowerDate)!
        
        eventList.forEach { event in
            if event.date >= lowerDate && event.date <= upperDate {
                eventWithinNDays.append(event)
            }
        }
        
        return eventWithinNDays
    }
    
    var body: some View {
        VStack {
            if isNearestEventAvailable {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(nearestEventList) { event in
                            NavigationLink(value: event.SIG!) {
                                SpotlightCard(event)
                                    .containerRelativeFrame(.horizontal, count: 1, spacing: 100)
                            }
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 10))
                    
                    Image(systemName: "circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                }
                .padding(.top, 5)
                
                //        .safeAreaPadding(.horizontal, 30)
//                .contentMargins(.horizontal,, for: .scrollContent)
                .scrollTargetBehavior(.paging)
            } else {
                GroupBox(label: Text("No Event To Show")) {
                    Text("You're up to date! :)")
                        .frame(height: 400)
                }
            }
        }
        
        
    }
}

//MARK: - No Result View
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

// MARK: - Categorized SIG View
struct SIGCategorizedView: View {
    @Binding var categories: [String]
    @Binding var categorizedSIGList: [String: [SIGModel]]
    
    var body: some View {
        Group {
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
                .padding(.top, 20)
                .padding(.bottom, 0)
                
                // TODO: Implement .viewAligned
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
}
