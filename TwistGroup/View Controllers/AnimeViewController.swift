//
//  AnimeViewController.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import UIKit
import SPIndicator
import Nuke

private let reuseIdentifier = "animeCell"

class AnimeViewController: UICollectionViewController {

    var filter: Filter = .all
    var anime: [Anime] = []
    var selectedAnime: Anime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwistAPI.shared.getAnime(filter: filter)
        TwistAPI.shared.animeListDelegate = self
    }


    func updateAnime(filter: Filter) {
        switch filter {
        case .all:
            self.title = "All Anime"
        case .trending:
            self.title = "Trending Anime"
        case .airing:
            self.title = "Airing Anime"
        case .rated:
            self.title = "Highly Rated Anime"
        }
        TwistAPI.shared.getAnime(filter: filter)
    }

    // MARK: -UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.anime.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AnimeCollectionViewCell
        let posterRequest = ImageRequest(url: URL(string: anime[indexPath.item].nejire_extension.poster_image)!)
        Nuke.loadImage(with: posterRequest, into: cell.posterImage)
        cell.posterImage.layer.cornerRadius = 12
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedAnime = anime[indexPath.item]
        self.performSegue(withIdentifier: "detail", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? AnimeDetailViewController {
            detailVC.anime = selectedAnime
        }
    }
    
}

extension AnimeViewController: ListDelegate {
    
    func didGetAnime(anime: [Anime]) {
        print(anime.count)
        self.anime = anime
        DispatchQueue.main.async {
            SPIndicator.present(title: "Success", preset: .done)
            self.collectionView.reloadData()
        }
    }
    
    func didFail(with error: Error) {
        DispatchQueue.main.async {
            SPIndicator.present(title: "Error", preset: .error)
        }
    }
    
    
}
