//
//  EventModel.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 05/04/25.
//

import Foundation

struct EventModel: Identifiable, Hashable {
    
    static var eventList: [EventModel] = populateEventList()
    static var eventDict: [String: [EventModel]] = Dictionary(grouping: eventList, by: { $0.SIG })
    
    var id: UUID = UUID()
    
    var name: String
    var description: String
    var price: Double
    var SIG: String
    var date: Date
    var Image: String
    
    var formattedDate: String {
        EventModel.df.string(from: date)
    }
    
    var weekday: String {
        date.formatted(.dateTime.weekday(.abbreviated))
    }
    
    private static var df: DateFormatter =  {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy HH:mm"
        return df
    }()
    
    init(name: String, description: String, price: Double, SIG: String, date: String, Image: String) {
        self.name = name
        self.description = description
        self.price = price
        self.SIG = SIG
        self.Image = Image
        self.date = EventModel.df.date(from: date) ?? Date()
    }
    
    static func populateEventList() -> [EventModel] {
        
        let eventList: [EventModel] = [
            .init(name: "Mabar MLBB", description: "Push rank together 'til we reach mythic! :)", price: 0, SIG: "GMA", date: "20/3/25 20:00", Image: "🏆"),
            .init(name: "Archery Practice", description: "Push rank together 'til we reach mythic! :)", price: 100_000, SIG: "Hungers Games", date: "22/03/2025 09:00", Image: "🏹")
        ]
        
        return eventList
    }
}
