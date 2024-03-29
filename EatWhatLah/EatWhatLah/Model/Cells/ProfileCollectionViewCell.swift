//
//  ProfileCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Ajaeson on 27/1/21.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    var lpost:Post!
    static let identifier = "ProfileCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func configure(with post: Post){
        lpost = post
        imageView.image = post.postImage
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        
    }
}
