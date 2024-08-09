//
//  YoutubeResponse.swift
//  Netflix
//
//  Created by Mabast on 2024-08-09.
//

struct YoutubeResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoID
}

struct VideoID: Codable {
    let kind: String
    let videoId: String
}
