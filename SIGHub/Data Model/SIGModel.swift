//
//  SIGModel.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import Foundation
import SwiftData


struct SIGModel: Identifiable, Hashable {

    static var SIGList: [SIGModel] = getData()
    static var SIGDict: [String: [SIGModel]] = Dictionary(grouping: SIGList, by: { $0.name })
    
    var id: UUID
    
    var name: String
    var realName: String
    var desc: String
    var session: String
    var category: String
    var image: String
    var whatsapp_link: String
    var pp: String
    
    var events: [EventModel?]
    var videos: [VideoModel?]
    
    init(_ name: String, _ realName: String, _ desc: String, _ session: String, _ category: String, _ image:  String, _ whatsapp_link: String, _ pp: String) {
        self.id = UUID()
        self.name = name
        self.realName = realName
        self.desc = desc
        self.session = session
        self.category = category
        self.image = image
        self.whatsapp_link = whatsapp_link
        
        self.events = EventModel.eventDict[name] ?? []
        self.videos = VideoModel.videoDict[name] ?? []
        self.pp = pp
    }
    
    static func getData() -> [SIGModel] {
        let SIGLists: [SIGModel] = [
            SIGModel("TrApple", "Traveling", "TrApple is a Student Interest Group for travel enthusiasts who are passionate about exploring new places, cultures, and experiences. Whether it’s discovering hidden gems nearby or planning exciting international adventures, TrApple brings together curious minds who share a love for travel. Through fun trips, travel talks, cultural exchanges, and planning sessions, members connect over their wanderlust and create unforgettable memories. Come for the destinations, stay for the stories!", "Morning", "Physical", "Trapple", "wa.link/hehe", "PP_Trapple"),
            SIGModel("Mewing Club", "Gym", "The Mewing Club is your go-to SIG for all things fitness and health! Whether you’re into weightlifting, yoga, or bodyweight training, this group is dedicated to helping you build strength, improve your health, and stay active. Join Mewing Club and work towards becoming the best version of yourself!", "Afternoon", "Physical", "Mewing", "wa.link/hehe", "PP_Mewing"),
            SIGModel("Kok Terbang?", "Badminton", "Are you a badminton enthusiast or looking to learn the sport? Kok Terbang? is the SIG for you! Whether you’re a seasoned player or a beginner, this group offers a friendly and competitive environment to improve your skills, have fun, and meet others who share the same love for the game. Come swing that shuttlecock with us!", "Afternoon", "Physical", "KokTerbang", "wa.link/hehe", "PP_HungerGames"),
            SIGModel("Blue Band", "Band", "Blue Band is where music lovers unite! If you’re passionate about playing instruments, singing, or composing, this SIG is your creative outlet. Whether you’re a guitarist, drummer, or vocalist, come jam with us and be part of something special. Join Blue Band and let’s make beautiful music together!", "Afternoon", "Art", "BlueBand", "wa.link/hehe", "PP_BlueBand"),
            SIGModel("Gorengan", "Investment", "Interested in learning about investment and finance? Gorengan is the SIG for you! From stocks to cryptocurrencies, this group will guide you through the world of investments. Whether you’re just starting or already know the ropes, Gorengan offers a community to share knowledge, strategies, and financial tips. Dive into the world of wealth-building with us!", "Afternoon", "Growth", "Gorengan", "wa.link/hehe", "PP_Gorengan"),
            SIGModel("Magic Hand", "Drawing", "Magic Hand is for all the creative souls who love to draw and sketch! Whether you’re into digital art, pencil sketches, or painting, this SIG provides a platform to hone your artistic skills and share your creations. If you enjoy expressing yourself through art, join Magic Hand and let your imagination flow!", "Morning", "Art", "MagicHand", "wa.link/hehe", ""),
            SIGModel("Pictahunt", "Photography", "IPictahunt is the perfect SIG for those passionate about capturing moments through the lens. From beginners to advanced photographers, this group welcomes anyone eager to explore the world of photography. Join us to learn new techniques, discover beautiful places, and share your photos with fellow enthusiasts. Don’t miss the chance to turn your passion for photography into an adventure!", "Morning", "Art", "Pictahunt", "wa.link/hehe", "PP_Pictahunt"),
            SIGModel("iMand", "Mandarin", "If you’re interested in learning Mandarin or improving your language skills, iMand is the SIG for you! Whether you’re a beginner or looking to deepen your knowledge, this group offers a supportive environment to practice speaking, reading, and writing in Mandarin. Join iMand and unlock the beauty of one of the most spoken languages in the world!", "Morning & Afternoon", "Growth", "iMand", "wa.link/hehe", "PP_iMand"),
            SIGModel("Apple TV", "Movie", "Apple TV is the SIG for movie lovers! If you enjoy watching and discussing films, from the classics to the latest releases, this group is the place for you. We dive deep into movie analysis, share recommendations, and host movie nights. Join Apple TV and be part of a cinematic journey with fellow movie buffs!", "Morning", "Entertainment", "Appletv", "wa.link/hehe", "PP_AppleTV"),
            SIGModel("GMA", "Game", "GMA is the perfect SIG for gamers! Whether you’re into console, PC, or mobile gaming, this group brings together gamers to compete, collaborate, and enjoy gaming in all its forms. From casual play to tournaments, there’s something for everyone. Join GMA, level up, and be part of our gaming community!", "Morning", "Entertainment", "GMA", "wa.link/hehe", "PP_GMA"),
            SIGModel("Hungers Games", "Archery", "Looking to improve your aim or learn the art of archery? Hungers Games is the SIG for anyone who’s passionate about this exciting sport. Whether you’re a beginner or experienced archer, this group will teach you the skills you need while offering a supportive and fun environment. Draw your bow and join us in the ultimate archery experience!", "Morning & Afternoon", "Physical", "HungerGames", "wa.link/hehe", "PP_HungerGames")]
        
        return SIGLists
    }
    
    static func getByName(_ name: String) -> SIGModel? {
        return SIGModel.SIGDict[name]?[0]
    }
    
    static func getSample() -> SIGModel {
        return SIGList[10]
    }
    
    // MARK: - Hashable dump
    static func == (lhs: SIGModel, rhs: SIGModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(realName)
    }
}
