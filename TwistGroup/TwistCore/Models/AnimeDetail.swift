//
//  AnimeDetail.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import Foundation

struct AnimeDetail: Codable {
    var id: Int
    var title: String
    var alt_title: String?
    var season: Int
    var ongoing: Int
    var description: String
    var hidden: Int
    var mal_id: Int?
    var slug: Slug
    var episodes: [Episode]
}

struct Episode: Codable {
    var id: Int
    var number: Int
    var anime_id: Int
}

struct Source: Codable {
    var id: Int
    var source: String
    var number: Int
    var anime_id: Int
    
    func decodedSource() -> String {
        return Twist.cdn + (CryptoJS.AES.shared.decrypt(self.source , password: Twist.Constant.key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
}
