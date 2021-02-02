//
//  ATFCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Ajaeson on 28/1/21.
//

import UIKit

class ATFCollectionViewCell: UICollectionViewCell {

    @IBOutlet var contentImage:UIImageView!
    var postLocal:Post!
    static let identifier = "ATFCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with post:Post){
        postLocal = post
        contentImage.image = post.postImage
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "ATFCollectionViewCell", bundle: nil)
        
    }
}
