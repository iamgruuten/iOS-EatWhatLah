//
//  FavouriteCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Apple on 30/1/21.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var venueImage: UIImageView!
    @IBOutlet var venueName: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    
    func configureCell(place:Places){
        
        self.venueName.text = place.venueName;
        self.venueImage.image = place.venueImageData
    }
    
    class var reuseIdentifier: String {
        return "favouriteCell"
    }
}

