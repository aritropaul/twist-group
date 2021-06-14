//
//  Jikan.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/13/21.
//

import Foundation
import OSLog
import SwiftSoup

protocol JikanEpisodeDelegate: AnimeDelegate {
    func didGetEpisodeData(episodeData: JikanEpisodeResponse)
}

protocol JikanAnimeDelegate: AnimeDelegate {
    func didGetAnimeData(animeData: JikanAnime)
}

class Jikan {
    static let shared = Jikan()
    
    weak var episodeDelegate: JikanEpisodeDelegate?
    weak var animeDelegate: JikanAnimeDelegate?
    
    //MARK: - Generic Request
    private func request<T:Codable>(base: String, endpoint: String, completion: @escaping(Result<T, TwistError>) -> ()) {
        let url = URL(string: base + endpoint)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            logger.log("🔌 URL: \(url)")
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
                logger.log("✅ Decode Success")
            }
            catch ( let error) {
                completion(.failure(.failedToDecode))
                logger.critical("\(error.localizedDescription)")
                print(error)
                logger.log("❌ Decode Failed")
            }
        }
        task.resume()
    }
    
    
    
    //MARK: - Anime Data
    func getAnimeData(anime: Int) {
        request(base: "https://api.jikan.moe/v3/anime", endpoint: "/\(anime)") { (result: Result<JikanAnime, TwistError>) in
                switch(result) {
                case .success(let data): self.animeDelegate?.didGetAnimeData(animeData: data)
                case .failure(let error): self.animeDelegate?.didFail(with: error)
            }
        }
    }
    
    
    
    
    //MARK: - Episode Data
    
    func getEpisodeData(anime: Int, page: Int = 1) {
        request(base: "https://api.jikan.moe/v3/anime", endpoint: "/\(anime)/episodes/\(page)") { (result: Result<JikanEpisodeResponse, TwistError>) in
            switch(result) {
            case .success(let data): self.episodeDelegate?.didGetEpisodeData(episodeData: data)
            case .failure(let error): self.episodeDelegate?.didFail(with: error)
            }
        }
    }
    
    func getEpisodeThumbnail(url: String, completion: @escaping(String) -> ()) {
        let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let session = URLSession.shared
        let cache = URLCache.shared
        if let cachedResponse = cache.cachedResponse(for: request) {
            logger.log("💾 From Cache")
            let html = String(data: cachedResponse.data, encoding: .utf8) ?? ""
            let soup = try! SwiftSoup.parse(html)
            let video = try! soup.select("div.video-embed.clearfix")
            let thumbnail = try! video.select("img.lazyload").attr("data-src")
            completion(thumbnail)
        }
        let task = session.dataTask(with: request) { data, response, error in
            logger.log("⬇️ Not From Cache")
            guard let data = data else { return }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                }
            }
            let html = String(data: data, encoding: .utf8) ?? ""
            let soup = try! SwiftSoup.parse(html)
            let video = try! soup.select("div.video-embed.clearfix")
//            print(try! video.html(
            let thumbnail = try! video.select("img.lazyload").attr("data-src")
            completion(thumbnail)
        }
        task.resume()
    }
    
    func crunchyRollParser(url: String, completion: @escaping(String)->()) {
        let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let session = URLSession.shared
        let cache = URLCache.shared
        if let cachedResponse = cache.cachedResponse(for: request) {
            logger.log("💾 From Cache")
            let html = String(data: cachedResponse.data, encoding: .utf8) ?? ""
            let soup = try! SwiftSoup.parse(html)
            let frame = try! soup.select("iframe").attr("src")
            print(html)
            iframeParser(url: frame) { thumbnail in
                completion(thumbnail)
            }
        }
        let task = session.dataTask(with: request) { data, _, Error in
            logger.log("⬇️ Not From Cache")
            guard let data = data else { return }
            let html = String(data: data, encoding: .utf8) ?? ""
            let soup = try! SwiftSoup.parse(html)
            let frame = try! soup.select("iframe").attr("src")
            print(html)
            self.iframeParser(url: frame) { thumbnail in
                completion(thumbnail)
            }
        }
        task.resume()
    }
    
    func iframeParser(url: String, completion: @escaping(String)->()) {
        let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let session = URLSession.shared
        let cache = URLCache.shared
        if let cachedResponse = cache.cachedResponse(for: request) {
            logger.log("💾 From Cache")
            let html = String(data: cachedResponse.data, encoding: .utf8) ?? ""
            let soup = try! SwiftSoup.parse(html)
            let video = try! soup.select("video#vjs-tech")
            print(try! video.html())
            let thumbnail = try! video.attr("poster")
            completion(thumbnail)
        }
        let task = session.dataTask(with: request) { data, response, Error in
            logger.log("⬇️ Not From Cache")
            guard let data = data else { return }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                }
            }
            let html = String(data: data, encoding: .utf8) ?? ""
            let soup = try! SwiftSoup.parse(html)
            let video = try! soup.select("video#vjs-tech")
            print(try! video.html())
            let thumbnail = try! video.attr("poster")
            completion(thumbnail)
        }
        task.resume()
    }
}
