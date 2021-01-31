//
//  FavouriteCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Apple on 30/1/21.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var venueDistance: UILabel!
    @IBOutlet var venueImage: UIImageView!
    
    @IBOutlet var venueAddress: UILabel!
    @IBOutlet var venueName: UILabel!
    
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    
    func configureCell(place:Places){
        
        self.venueName.text = place.venueName;
        self.venueAddress.text = place.venueAddress;
        self.venueImage.image = place.venueImageData
        self.venueDistance.text = String(place.distance)
    }
    
    class var reuseIdentifier: String {
        return "favouriteCell"
    }
}

