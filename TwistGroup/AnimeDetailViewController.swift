//
//  AnimeDetailViewController.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import UIKit
import Kingfisher
import AVKit

class AnimeDetailViewController: UIViewController {

    var anime: Anime!
    var details: AnimeDetail!
    var sources: [Source] = []
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.posterImage.kf.setImage(with: URL(string: anime.nejire_extension.poster_image))
        self.coverImage.kf.setImage(with: URL(string: anime.nejire_extension.cover_image))
        self.coverImage.contentMode = .scaleAspectFill
        self.posterImage.layer.cornerRadius = 12
        self.posterImage.makeCard()
        self.titleLabel.text = anime.title
        TwistAPI.shared.animeDetailDelegate = self
        TwistAPI.shared.sourcesDelegate = self
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        loadData()
        
    }
    
    func loadData() {
        Defaults.shared.load()
        playButton.titleLabel?.text = "   Episode \(playData[anime.slug.slug] ?? 1)"
        TwistAPI.shared.getAnimeDetails(slug: anime.slug.slug)
        TwistAPI.shared.getAnimeSources(slug: anime.slug.slug)
    }

    func play(slug: String, episode: Int, url: URL) {
        
        playData[slug] = episode
        Defaults.shared.save()
        
        let headerFields: [String:String] = ["Referer":"https://twist.moe/a/\(slug)/\(episode)"]
        print("url: \(url)")
        let asset: AVURLAsset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headerFields])
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.player?.play()
        self.present(playerViewController, animated: true)
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if sources.count > 0 {
            Defaults.shared.load()
            let lastEpisode = playData[details?.slug.slug ?? ""] ?? 1
            let url = URL(string: sources[lastEpisode - 1].decodedSource())!
            self.play(slug: details?.slug.slug ?? "", episode: lastEpisode, url: url)
        }
    }
    
}

extension AnimeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell")!
        cell.textLabel?.text = "Episode \(sources[indexPath.row].number)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = sources[indexPath.row].number
        let url = URL(string: sources[indexPath.row].decodedSource())!
        let slug = (details?.slug.slug)!
        self.play(slug: slug, episode: episode, url: url)
        
    }
    
}


extension AnimeDetailViewController: DetailsDelegate, SourcesDelegate {
    
    func didGetDetails(anime: AnimeDetail) {
        self.details = anime
        DispatchQueue.main.async {
            self.descriptionLabel.text = self.details?.description
        }
    }
    
    func didGetSources(sources: [Source]) {
        self.sources = sources
        print(sources.count)
        DispatchQueue.main.async {
            if sources.count == 0 {
                self.playButton.isUserInteractionEnabled = false
            }
            self.episodesTableView.reloadData()
        }
    }
    
    func didFail(with error: Error) {
        print(error)
    }
    
    
}
