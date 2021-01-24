//
//  nearbyCellCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Apple on 24/1/21.
//

import UIKit

class nearbyCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var distanceTextLabel: UILabel!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var venueTextLabel: UILabel!
    @IBOutlet weak var ratingTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    func configureCell(place: Places) {
        distanceTextLabel.text = String(place.distance);
        venueImageView.image = place.venueImage;
        venueTextLabel.text = String(place.venueName);
        ratingTextLabel.text = String(place.rating);
    }
    
    class var reuseIdentifier: String {
        return "CollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "nearbyCellCollectionViewCell"
    }

}
