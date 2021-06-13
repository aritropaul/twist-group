//
//  Endpoints.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import Foundation

struct Twist {
    static let base = "https://api.twist.moe/api"
    static let anime = "/anime/"
    static let sources = "/sources"
    static let suzuha = "https://twist.suzuha.moe/"
    static let cdn = "https://air-cdn.twist.moe"
    
    struct Constant {
        static let key = "267041df55ca2b36f2e322d05ee2c9cf"
    }
}

enum Filter: String {
    case all = "/anime"
    case trending = "list/trending/anime?limit="
    case airing = "list/anime?page[limit]=20&sort=-user_count&filter[status]=current&page[offset]="
    case rated = "list/anime?page[limit]=20&sort=-average_rating&page[offset]="
}
