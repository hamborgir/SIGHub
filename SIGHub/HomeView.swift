//
//  HomeView.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var navtitle: String = "Discover" //nanti ganti (jangan home)
    @State private var path = NavigationPath()
    
    @State var SIGList: [SIGModel] = SIGModel.SIGList
    @State var categories: [String]  = getCategory(SIGModel.SIGList)
    @State private var categorizedSIGList: [String: [SIGModel]] = Dictionary(grouping: SIGModel.getData()) { $0.category }
    
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
    
    func saveVideoIfNotExists(videoURL: URL, fileName: String) {
        let fileManager = FileManager.default
        do {
            // Get the documents directory URL
            let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationURL = documentDirectoryURL.appendingPathComponent(fileName)
            
            // Check if the file already exists at the destination
            if !fileManager.fileExists(atPath: destinationURL.path) {
                // Copy the file to the destination if it doesn't exist
                try fileManager.copyItem(at: videoURL, to: destinationURL)
                print("Video saved successfully.")
            } else {
                print("File already exists, skipping save.")
            }
        } catch {
            print("Error saving video: \(error.localizedDescription)")
        }
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
//                                HStack {
//                                    Text("Discover")
//                                        .font(.title)
//                                        .fontWeight(.bold)
//                                }
//                                .padding(.top, 10)
                                
                                Text("Upcoming Events")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                                
                                Text("Check out the exciting events happening in the next 7 days!")
                                    .font(.subheadline)
                                
                                    
                            }
                            
                            // Spotlight Event
                            SpotlightView()
                            
                            
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
                    navtitle = "Discover"
                }
            }
            .navigationTitle(navtitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: SIGModel.self) { SIG in
                //                 For spotlight and SIGcards
                
                DetailsView(SIG: SIG, path: $path, navtitle: navtitle)
                    .padding(.bottom, 20)
                    .ignoresSafeArea()
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
            .navigationDestination(for: Int.self) {event in
                VideoView(path: $path)
                    .navigationBarHidden(true)
                    
            }
            
            
            Spacer()
        }
        .onAppear {
            let url = Bundle.main.url(forResource: "defaultVideo", withExtension: "mp4")!
            let fileName = "defaultVideo.mp4"
            saveVideoIfNotExists(videoURL: url, fileName: fileName)
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
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            if isNearestEventAvailable {
                VStack {
                    TabView(selection: $currentIndex) {
                        ForEach(nearestEventList.indices, id: \.self) { index in
                            NavigationLink(value: nearestEventList[index].SIG!) {
                                SpotlightCard(nearestEventList[index])
                                    .tag(index)
                                    
                            }
                        }
                    }
                    .frame(height: 410)
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    HStack {
                        ForEach(nearestEventList.indices, id: \.self) { index in
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentIndex = index
                                }
                            } label: {
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(
                                        currentIndex == index
                                        ? .blue : .gray.opacity(0.5))
                                    .transition(.scale)
                            }

                        }
                    }
                }
                
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
                                .foregroundColor(.accentColor)
                                .fontWeight(.bold)
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
                .scrollTargetLayout(isEnabled: true)
                .scrollTargetBehavior(.viewAligned)
            }
        }
    }
}
