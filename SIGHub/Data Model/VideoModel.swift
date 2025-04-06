//
//  VideoModel.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 05/04/25.
//

import Foundation

struct VideoModel: Identifiable, Hashable {
    static var videoList: [VideoModel] = populateVideoList()
    static var videoDict: [String: [VideoModel]] = Dictionary(grouping: videoList, by: { $0.SIG })
    
    var id: UUID = UUID()
    
    var video: String
    var SIG: String
    
    init(video: String, SIG: String) {
        self.video = video
        self.SIG = SIG
    }
    
    static func populateVideoList() -> [VideoModel] {
        let videoList: [VideoModel] = [
            .init(video: "", SIG: "Hungers Games")
        ]
        
        return videoList
    }
}
