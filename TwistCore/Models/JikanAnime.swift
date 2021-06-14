//
//  JikanAnime.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/13/21.
//

import Foundation

struct JikanAnime: Codable {
    var mal_id: Int
    var url: String
    var image_url: String
    var trailer_url: String
    var title: String
    var title_english: String?
    var title_japanese: String?
    var episodes: Int?
    var status: String
    var duration: String
    var rating: String
    var premiered: String?
    var score: Double
    var synopsis: String
    var genres: [JikanGenre]
}

struct JikanGenre: Codable {
    var mal_id: Int
    var name: String
}
