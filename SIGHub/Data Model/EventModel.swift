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
    var Image: String
    
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
    
    
    init(name: String, description: String, price: Double, SIGName: String, date: String, Image: String) {
        self.name = name
        self.description = description
        self.price = price
        self.SIGName = SIGName
        self.Image = Image
        self.date = MyDateFormatter.fromString(date) ?? Date()
    }
    
    static func populateEventList() -> [EventModel] {
        
        let eventList: [EventModel] = [
            .init(name: "Mabar MLBB", description: "Push rank together 'til we reach mythic! :)", price: 0, SIGName: "GMA", date: "20/3/25 20:00", Image: "🏆"),
            .init(name: "Archery Practice", description: "Push rank together 'til we reach mythic! :)", price: 100_000, SIGName: "Hungers Games", date: "22/03/2025 09:00", Image: "🏹"),
            .init(name: "Archery Practice", description: "Push rank together 'til we reach mythic! :)", price: 100_000, SIGName: "Hungers Games", date: "10/04/2025 09:00", Image: "🏹")
        ]
        
        
        return eventList.sorted { $0.date < $1.date }
    }
}
