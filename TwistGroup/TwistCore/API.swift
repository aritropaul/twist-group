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
    private func request<T:Codable>(base: String, endpoint: String, completion: @escaping(Result<T, TwistError>) -> ()) {
        let url = URL(string: base + endpoint)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            print(url)
            print(String(data: data, encoding: .utf8))
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            }
            catch ( _) {
                completion(.failure(.failedToDecode))
            }
        }
        task.resume()
    }
    
    
    //MARK: - Requests
    
    /// Gets the Anime with the given filter
    ///
    /// Main method to fetch lists of anime based to a precoded filter.
    /// Custom filters can be coded in the `Endpoints.swift` file
    ///
    /// When called, gets an array of `anime` with the passed `filter`
    ///
    /// - Parameters:
    ///   - filter: an option of `Filter`
    ///
    /// - Returns: A list of `Anime`
    ///
    /// - Throws: `TwistError.failedToDecode` if the JSONDecoder() fails.
    func getAnime(filter: Filter) {
        let base = Twist.suzuha
        let endpoint = filter.rawValue
        request(base: base, endpoint: endpoint) { (result: Result<[Anime], TwistError>) in
            switch(result) {
            case .success(let anime): self.animeListDelegate?.didGetAnime(anime: anime)
            case .failure(let error): self.animeListDelegate?.didFail(with: error)
            }
        }
    }
    
    
    /// Gets the details of the anime request
    ///
    /// Main method to fetch lists of anime based to a precoded filter.
    /// Custom filters can be coded in the `Endpoints.swift` file
    ///
    /// When called, gets an array of `anime` with the passed `filter`
    ///
    /// - Parameters:
    ///   - filter: an option of `Filter`
    ///
    /// - Returns: A list of `Anime`
    ///
    /// - Throws: `TwistError.failedToDecode` if the JSONDecoder() fails.
    func getAnimeDetails(slug: String) {
        let base = Twist.base
        let endpoint = Twist.anime + slug
        request(base: base, endpoint: endpoint) { (result: Result<AnimeDetail, TwistError>) in
            switch(result) {
            case .success(let anime): self.animeDetailDelegate?.didGetDetails(anime: anime)
            case .failure(let error): self.animeDetailDelegate?.didFail(with: error)
            }
        }
    }
    
    func getAnimeSources(slug: String) {
        let base = Twist.base
        let endpoint = Twist.anime + slug + Twist.sources
        request(base: base, endpoint: endpoint) { (result: Result<[Source], TwistError>) in
            switch(result) {
            case .success(let sources): self.sourcesDelegate?.didGetSources(sources: sources)
            case .failure(let error): self.sourcesDelegate?.didFail(with: error)
            }
        }
    }
    
}
