//
//  VideoModel.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 05/04/25.
//

import Foundation
import SwiftData

@Model
final class VideoModel: Identifiable, Hashable {
//    static var videoList: [VideoModel] = populateVideoList()
//    static var videoDict: [String: [VideoModel]] = Dictionary(grouping: videoList, by: { $0.SIG })
    
    @Attribute(.unique) var id: UUID
    @Attribute var video: String
    @Attribute var videoURL: URL
    
    init(id: UUID, video: String, videoURL: URL) {
        self.id = id
        self.video = video
        self.videoURL = videoURL
    }
    
    static func populateVideoList() -> [VideoModel] {
        let videoList: [VideoModel] = [
//            .init(video: "", SIG: "Hungers Games")
        ]
        
        return videoList
    }
}
