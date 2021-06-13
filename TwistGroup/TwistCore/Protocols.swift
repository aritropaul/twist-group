//
//  Protocols.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import Foundation

protocol AnimeDelegate: AnyObject {
    func didFail(with error: Error)
}

protocol ListDelegate: AnimeDelegate {
    func didGetAnime(anime: [Anime])
}

protocol DetailsDelegate: AnimeDelegate {
    func didGetDetails(anime: AnimeDetail)
}

protocol SourcesDelegate: AnimeDelegate {
    func didGetSources(sources: [Source])
}
