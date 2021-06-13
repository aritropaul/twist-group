//
//  AnimeViewController.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "animeCell"

class AnimeViewController: UICollectionViewController {

    var filter: Filter = .all
    var anime: [Anime] = []
    
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
        cell.posterImage.kf.setImage(with: URL(string: anime[indexPath.item].nejire_extension.poster_image))
        cell.posterImage.layer.cornerRadius = 12
        return cell
    }

}

extension AnimeViewController: ListDelegate {
    
    func didGetAnime(anime: [Anime]) {
        print(anime.count)
        self.anime = anime
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didFail(with error: Error) {
        print(error)
    }
    
    
}
