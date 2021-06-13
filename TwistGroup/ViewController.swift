//
//  ViewController.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        TwistAPI.shared.getAnime(filter: .rated)
//        TwistAPI.shared.getAnimeDetails(slug: "boruto-naruto-next-generations")
        TwistAPI.shared.getAnimeSources(slug: "kimetsu-no-yaiba")
        
        TwistAPI.shared.sourcesDelegate = self
        TwistAPI.shared.animeListDelegate = self
        TwistAPI.shared.animeDetailDelegate = self
    }

    func play(url: URL) {
        let headerFields: [String:String] = ["Referer":"https://twist.moe/a/\("kimetsu-no-yaiba")/\(1)"]
        print("url: \(url)")
        let asset: AVURLAsset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headerFields])
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.player?.play()
        self.present(playerViewController, animated: true)
    }

}

extension ViewController: ListDelegate {
    func didGetAnime(anime: [Anime]) {
        print(anime)
    }
    
    func didFail(with error: Error) {
        print(error)
    }
    
    
}

extension ViewController: DetailsDelegate {
    func didGetDetails(anime: AnimeDetail) {
        print(anime)
    }
    
    
}

extension ViewController: SourcesDelegate {
    func didGetSources(sources: [Source]) {
        let last = URL(string: sources.last?.decodedSource() ?? "")!
        DispatchQueue.main.async {
            self.play(url: last)
        }
        
        
    }
    
    
}
