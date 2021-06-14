//
//  AnimeDetailTableViewController.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/13/21.
//

import UIKit
import AVKit
import SPIndicator
import Nuke

class AnimeDetailTableViewController: UITableViewController {

    var anime: Anime!
    var details: AnimeDetail!
    var animeData: JikanAnime?
    var sources: [Source] = []
    var episodeData: [JikanEpisode] = []
    var page = 1
    
    var player = AVPlayer()
    var timer = Timer()
    var observer: NSKeyValueObservation?
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodeCollectionView: UICollectionView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var extrasLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = anime.title
        
        TwistAPI.shared.animeDetailDelegate = self
        TwistAPI.shared.sourcesDelegate = self
        Jikan.shared.episodeDelegate = self
        Jikan.shared.animeDelegate = self
        
        episodeCollectionView.delegate = self
        episodeCollectionView.dataSource = self
        
        let malID = String(describing: anime.mal_id)
        logger.log("📺 Anime: \(self.anime.slug.slug)")
        logger.log("🗳 MAL Id: \(malID)")
        
        self.extrasLabel.text = ""
        
        loadData()
        blurView.createGradientBlur()
        Defaults.shared.load()
        let lastEpisode = playData[anime.slug.slug] ?? 1
        let lastTime = String(describing: (timeData[anime.slug.slug])?["\(lastEpisode)"])
        logger.log("📺 Last Episode: \(lastEpisode)")
        logger.log("⏰ Last time: \(lastTime)")
        
        playButton.titleLabel?.text = "Watch Episode \(lastEpisode)"
        playButton.subtitleLabel?.text = "Episode \(lastEpisode)"
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        let coverRequest = ImageRequest(url: URL(string: anime.nejire_extension.cover_image)!)
        let posterRequest = ImageRequest(url: URL(string: anime.nejire_extension.poster_image)!)
        Nuke.loadImage(with: coverRequest, into: self.coverImage) { result in
            switch result {
            case .success(_): break
            case .failure(_):
                Nuke.loadImage(with: posterRequest, into: self.coverImage)
            }
        }
        self.coverImage.contentMode = .scaleAspectFill
        descriptionLabel.font = .systemFont(ofSize: 13)
        
        #if targetEnvironment(macCatalyst)
        descriptionLabel.numberOfLines = 5
        #endif
    }
    

    func loadData() {
        
        TwistAPI.shared.getAnimeDetails(slug: anime.slug.slug)
        TwistAPI.shared.getAnimeSources(slug: anime.slug.slug)
        guard let malID = anime.mal_id else { return }
        Jikan.shared.getEpisodeData(anime: malID)
        Jikan.shared.getAnimeData(anime: malID)
        
    }
    
    func play(slug: String, episode: Int, url: URL) {
        
        playData[slug] = episode
        Defaults.shared.save()
        
        let headerFields: [String:String] = ["Referer":"https://twist.moe/a/\(slug)/\(episode)"]
        print("url: \(url)")
        let asset: AVURLAsset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headerFields])
        let playerItem = AVPlayerItem(asset: asset)
        let playerViewController = AVPlayerViewController()
        
        self.player = AVPlayer(playerItem: playerItem)
        playerViewController.player = self.player
        playerViewController.player?.play()
        
        DispatchQueue.main.async {
            self.present(playerViewController, animated: true) {
                DispatchQueue.main.async {
                    SPIndicator.present(title: "Playing Episode \(episode)", preset: .custom(UIImage(systemName: "play.fill")!))
                }
            }
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if sources.count > 0 {
            let lastEpisode = playData[anime.slug.slug] ?? 1
            logger.log("📺 Last Episode: \(lastEpisode)")
            let url = URL(string: sources[ lastEpisode - 1].decodedSource())!
            self.play(slug: details?.slug.slug ?? "", episode: lastEpisode, url: url)
        }
    }
    
}


extension AnimeDetailTableViewController: DetailsDelegate, SourcesDelegate {
    
    func didGetDetails(anime: AnimeDetail) {
        self.details = anime
        DispatchQueue.main.async {
            self.descriptionLabel.text = self.details?.description
        }
    }
    
    func didGetSources(sources: [Source]) {
        self.sources = sources
        logger.log("📺 Episodes: \(sources.count)")
        DispatchQueue.main.async {
            if sources.count == 0 {
                self.playButton.isUserInteractionEnabled = false
            }
            self.episodeCollectionView.reloadData()
        }
    }
    
    func didFail(with error: Error) {
        
        if sources.count == 0 {
            let alert = UIAlertController(title: "Oops", message: "Seems like this anime isn't available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go Back", style: .cancel, handler: { action in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        DispatchQueue.main.async {
            SPIndicator.present(title: "Error", preset: .error, from: .bottom)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 30, y: 10, width: tableView.frame.size.width, height: 50))
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Episodes"
        view.addSubview(label)
        view.backgroundColor = .clear // Set your background color

        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}


extension AnimeDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCell", for: indexPath) as! EpisodeCollectionViewCell
        let coverRequest = ImageRequest(url: URL(string: anime.nejire_extension.cover_image)!)
        let posterRequest = ImageRequest(url: URL(string: anime.nejire_extension.poster_image)!)
        Nuke.loadImage(with: coverRequest, into: cell.thumbnail) { result in
            switch result {
            case .success(_): break
            case .failure(_):
                Nuke.loadImage(with: posterRequest, into: cell.thumbnail)
            }
        }
        cell.thumbnail.contentMode = .scaleAspectFill
        cell.thumbnail.layer.cornerRadius = 12
        if episodeData.count > 0 {
            cell.nameLabel.text = episodeData[indexPath.item].title
            if let videoURL = episodeData[indexPath.item].video_url {
                Jikan.shared.getEpisodeThumbnail(url: videoURL) { imageURL in
                    let thumbnail = ImageRequest(url: (URL(string: imageURL) ?? URL(string: self.anime.nejire_extension.cover_image)!))
                    DispatchQueue.main.async {
                        logger.log("🏞 Thumbnail: \(imageURL)")
                        Nuke.loadImage(with: thumbnail, into: cell.thumbnail) { result in
                            switch result {
                            case .success(_): break
                            case .failure(_):
                                Nuke.loadImage(with: coverRequest, into: cell.thumbnail) { result in
                                    switch result {
                                    case .success(_): break
                                    case .failure(_):
                                        Nuke.loadImage(with: posterRequest, into: cell.thumbnail)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            cell.episodeLabel.text = "Episode \(sources[indexPath.item].number)".capitalized
        }
        else {
            cell.nameLabel.text = "Episode \(sources[indexPath.item].number)".capitalized
            cell.episodeLabel.text = ""
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episode = sources[indexPath.item].number
        let url = URL(string: sources[indexPath.item].decodedSource())!
        let slug = (anime?.slug.slug)!
        self.play(slug: slug, episode: episode, url: url)
    }
    
}

extension AnimeDetailTableViewController: JikanEpisodeDelegate {
    
    func didGetEpisodeData(episodeData: JikanEpisodeResponse) {
        if self.episodeData.isEmpty {
            self.episodeData = episodeData.episodes
        }
        else {
            self.episodeData.append(contentsOf: episodeData.episodes)
        }
        print(self.episodeData.count)
        page = page + 1
        if page > episodeData.episodes_last_page {
            page = 1
        }
        else {
            guard let malID = anime.mal_id else { return }
            Jikan.shared.getEpisodeData(anime: malID, page: page)
        }
        DispatchQueue.main.async {
            self.episodeCollectionView.reloadData()
        }
    }
    
}


extension AnimeDetailTableViewController : JikanAnimeDelegate {
    func didGetAnimeData(animeData: JikanAnime) {
        self.animeData = animeData
        DispatchQueue.main.async {
            self.descriptionLabel.text = animeData.synopsis
            let genre = animeData.genres[0].name + "    "
            let premier = animeData.premiered != nil ? (animeData.premiered! + "    ") : ""
            let duration = animeData.duration.replacingOccurrences(of: " per ep", with: "") + "    "
            let rating = animeData.rating.components(separatedBy: " ")[0]
            let dataString = genre + premier + duration + rating
            self.extrasLabel.text = dataString
        }
    }
}
