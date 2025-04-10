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
    
    var countdown: Int {
        var currentDate = Date()
        var calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: currentDate, to: self.date)
        
        return components.day ?? 0
    }
    
    var countdownString: String {
        if countdown == 0 {
            return "HAPPENING TODAY!"
        }
        else {
            return "HAPENNING IN \(countdown) DAYS"
        }
    }
    
    var priceString: String {
        if price == 0 {
            return "FREE!"
        }
        
        return "Rp\(Int(price).formatted())"
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
            .init(name: "Traveling to Bali", description: "Join us for a trip to Bali to explore the beauty and culture of the island.", price: 2_500_000, SIGName: "TrApple", date: "25/04/2025 08:00", image: "✈️", location: "Bali"),
            .init(name: "Urban Eats: Blok M", description: "Let's explore viral foods hidden within the 'Hawker Street' of Jakarta.", price: 0, SIGName: "TrApple", date: "25/04/2025 08:00", image: "🏙️", location: "Jakarta"),
            .init(name: "Badminton Friendly Match", description: "Let's have a friendly badminton match to improve our skills and have fun together.", price: 50_000, SIGName: "Kok Terbang?", date: "27/03/2025 16:00", image: "🏸", location: "Gymnasium"),
            .init(name: "Band Rehearsal", description: "Practice with the band and prepare for our next concert. Let's make some great music!", price: 0, SIGName: "Blue Band", date: "14/04/2025 18:00", image: "🎶", location: "Music Room"),
            .init(name: "Investment Workshop", description: "Learn the basics of investing and managing finances in this informative workshop.", price: 150_000, SIGName: "Gorengan", date: "05/05/2025 14:00", image: "💰", location: "Conference Room A"),
            .init(name: "Gym Session", description: "A group workout session to get in shape and improve fitness together.", price: 75_000, SIGName: "Mewing Club", date: "07/05/2025 07:00", image: "💪", location: "Gold's Gym BSD"),
            .init(name: "Mogging Session", description: "A group workout session to get in shape and improve fitness together.", price: 75_000, SIGName: "Mewing Club", date: "28/04/2025 07:00", image: "💪", location: "Gold's Gym BSD"),
            .init(name: "Drawing Workshop", description: "Learn the art of drawing and improve your skills in this fun and creative workshop.", price: 50_000, SIGName: "Magic Hand", date: "10/05/2025 11:00", image: "🎨", location: "Art Room"),
            .init(name: "Photography Walk", description: "Join us for a photography walk around the city and capture beautiful moments.", price: 0, SIGName: "Pictahunt", date: "12/04/2025 09:00", image: "📸", location: "City Center"),
//            .init(name: "Photography Walk", description: "Join us for a photography walk around the city and capture beautiful moments.", price: 0, SIGName: "Pictahunt", date: "12/04/2025 09:00", image: "📸", location: "City Center"),
            .init(name: "Mandarin Language Meetup", description: "Practice speaking Mandarin with fellow enthusiasts and improve your skills!", price: 0, SIGName: "iMand", date: "15/04/2025 18:00", image: "🈶", location: "Language Lab"),
            .init(name: "Movie Night", description: "Come and enjoy a movie screening with friends, snacks, and great discussions!", price: 20_000, SIGName: "Apple TV", date: "18/05/2025 19:00", image: "🍿", location: "Jose's House"),
            .init(name: "Movie Night: The Sequel", description: "Come and enjoy a movie screening with friends, snacks, and great discussions!", price: 20_000, SIGName: "Apple TV", date: "20/05/2025 19:00", image: "🍿", location: "Ethel's House"),
            .init(name: "Game Night", description: "Compete with friends in various games and win exciting prizes!", price: 0, SIGName: "GMA", date: "20/05/2025 20:00", image: "🎮", location: "Online"),
            .init(name: "Archery Practice - Session 1", description: "Join us for the first archery practice and learn the basics of shooting.", price: 100_000, SIGName: "Hungers Games", date: "22/03/2025 08:00", image: "🏹", location: "Archery Range"),
            .init(name: "Archery Practice - Session 2", description: "Improve your archery skills in this second practice session.", price: 100_000, SIGName: "Hungers Games", date: "10/04/2025 08:00", image: "🏹", location: "Archery Range")
        ]
        
        
        return eventList.sorted { $0.date < $1.date }
    }
    
    static func getSample() -> EventModel {
        return eventList.first!
    }
}
