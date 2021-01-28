//
//  ATFCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Ajaeson on 28/1/21.
//

import UIKit

class ATFCollectionViewCell: UICollectionViewCell {

    @IBOutlet var contentImage:UIImageView!
    
    static let identifier = "ATFCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage){
        contentImage.image = image
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "ATFCollectionViewCell", bundle: nil)
        
    }
}
