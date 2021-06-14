//
//  EpisodeCollectionViewCell.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/13/21.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        self.thumbnail.image = nil
    }
    
}
