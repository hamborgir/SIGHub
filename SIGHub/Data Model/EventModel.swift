//
//  EventModel.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 05/04/25.
//

import Foundation

struct EventModel: Identifiable, Hashable {
    
    static var eventList: [EventModel] = populateEventList()
    static var eventDict: [String: [EventModel]] = Dictionary(grouping: eventList, by: { $0.SIGName })
    
    var id: UUID = UUID()
    
    var name: String
    var description: String
    var price: Double
    var SIGName: String
    var date: Date
    var image: String
    var location: String
    
    var SIG: SIGModel? {
        for SIG in SIGModel.SIGList where SIG.name == SIGName {
            return SIG
        }
        return nil
    }
    
    var formattedDate: String {
        MyDateFormatter.fromDate(self.date) ?? "Invalid Date"
    }
    
    var weekday: String {
        date.formatted(.dateTime.weekday(.abbreviated))
    }
    
    
    init(name: String, description: String, price: Double, SIGName: String, date: String, image: String, location: String) {
        self.name = name
        self.description = description
        self.price = price
        self.SIGName = SIGName
        self.image = image
        self.date = MyDateFormatter.fromString(date)!
        self.location = location
    }
    
    static func populateEventList() -> [EventModel] {
        
        let eventList: [EventModel] = [
            .init(name: "Mabar MLBB", description: "Push rank together 'til we reach mythic! :)", price: 0, SIGName: "GMA", date: "20/3/25 20:00", image: "🏆", location: "Online"),
            .init(name: "Archery Practice", description: "Practice together, improve your skills! This will be our first sesion.", price: 100_000, SIGName: "Hungers Games", date: "22/03/2025 09:00", image: "🏹", location: "BSD"),
            .init(name: "Archery Practice", description: "Practice together, improve your skills! This will be our second sesion.", price: 100_000, SIGName: "Hungers Games", date: "10/04/2025 09:00", image: "🏹", location: "BSD"),
            .init(name: "Archery Practice", description: "Practice together, improve your skills! This will be our second sesion.", price: 100_000, SIGName: "Hungers Games", date: "10/04/2025 09:00", image: "🏹", location: "BSD")
        ]
        
        
        return eventList.sorted { $0.date < $1.date }
    }
    
    static func getSample() -> EventModel {
        return eventList.first!
    }
}
