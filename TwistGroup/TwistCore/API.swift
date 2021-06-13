//
//  API.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import Foundation

class TwistAPI {
    static let shared = TwistAPI()
    
    //MARK: - Delegates
    weak var animeListDelegate: ListDelegate?
    weak var animeDetailDelegate: DetailsDelegate?
    weak var sourcesDelegate: SourcesDelegate?
    
    //MARK: - Generic Request
    func request<T:Codable>(base: String, endpoint: String, completion: @escaping(Result<T, Error>) -> ()) {
        let url = URL(string: base + endpoint)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
//            print(url)
//            print(String(data: data, encoding: .utf8))
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            }
            catch (let error) {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    //MARK: - Requests
    
    func getAnime(filter: Filter) {
        let base = Twist.suzuha
        let endpoint = filter.rawValue
        request(base: base, endpoint: endpoint) { (result: Result<[Anime],Error>) in
            switch(result) {
            case .success(let anime): self.animeListDelegate?.didGetAnime(anime: anime)
            case .failure(let error): self.animeListDelegate?.didFail(with: error)
            }
        }
    }
    
    func getAnimeDetails(slug: String) {
        let base = Twist.base
        let endpoint = Twist.anime + slug
        request(base: base, endpoint: endpoint) { (result: Result<AnimeDetail, Error>) in
            switch(result) {
            case .success(let anime): self.animeDetailDelegate?.didGetDetails(anime: anime)
            case .failure(let error): self.animeDetailDelegate?.didFail(with: error)
            }
        }
    }
    
    func getAnimeSources(slug: String) {
        let base = Twist.base
        let endpoint = Twist.anime + slug + Twist.sources
        request(base: base, endpoint: endpoint) { (result: Result<[Source], Error>) in
            switch(result) {
            case .success(let sources): self.sourcesDelegate?.didGetSources(sources: sources)
            case .failure(let error): self.sourcesDelegate?.didFail(with: error)
            }
        }
    }
    
}
