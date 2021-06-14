//
//  JikanEpisode.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/13/21.
//

import Foundation

struct JikanEpisodeResponse: Codable {
    var episodes_last_page: Int
    var episodes: [JikanEpisode]
}

struct JikanEpisode: Codable {
    var episode_id: Int
    var title: String
    var title_japanese: String?
    var title_romanji: String?
    var aired: String?
    var filler: Bool
    var recap: Bool
    var video_url: String?
}
