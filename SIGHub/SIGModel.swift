//
//  SIGModel.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 26/03/25.
//

import Foundation
import SwiftData


@Model
class SIGModel: Identifiable {
    static var SIGList: [SIGModel] = getData()
    
    var id: UUID
    
    var name: String
    var realName: String
    var desc: String
    var session: String
    var category: String
    var image: String
    var whatsapp_link: String
    
    init(_ name: String, _ realName: String, _ desc: String, _ session: String, _ category: String, _ image:  String, _ whatsapp_link: String) {
        self.id = UUID()
        self.name = name
        self.realName = realName
        self.desc = desc
        self.session = session
        self.category = category
        self.image = image
        self.whatsapp_link = whatsapp_link
    }
    
    static func getData() -> [SIGModel] {
        let sigLists: [SIGModel] = [
            SIGModel("TrApple", "Traveling", "TrApple is a Student Interest Group for travel enthusiasts who are passionate about exploring new places, cultures, and experiences. Whether it’s discovering hidden gems nearby or planning exciting international adventures, TrApple brings together curious minds who share a love for travel. Through fun trips, travel talks, cultural exchanges, and planning sessions, members connect over their wanderlust and create unforgettable memories. Come for the destinations, stay for the stories!", "Morning", "Physical", "Trapple", "wa.link/hehe"),
            SIGModel("Mewing Club", "Gym", "we’re all about bringing fitness enthusiasts together in a supportive and motivating environment...", "Afternoon", "Physical", "Mewing", "wa.link/hehe")]
        
        return sigLists
    }
    
    static func getSample() -> SIGModel {
        return SIGList[0]
    }
}
