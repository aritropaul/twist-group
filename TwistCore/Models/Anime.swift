//
//  Anime.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import Foundation

struct Anime: Codable {
    var id: Int
    var title: String
    var alt_title: String?
    var season: Int
    var ongoing: Int
    var hidden: Int
    var mal_id: Int?
    var slug: Slug
    var nejire_extension: Nejire
}

struct Slug: Codable {
    var id: Int
    var slug: String
    var anime_id: Int
}

struct Nejire: Codable {
    var poster_image: String
    var cover_image: String
}
