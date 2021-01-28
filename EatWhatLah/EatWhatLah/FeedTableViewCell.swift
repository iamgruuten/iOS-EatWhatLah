//
//  FeedTableViewCell.swift
//  EatWhatLah
//
//  Created by Ajaeson on 28/1/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet var contentImage:UIImageView!
    
    static let identifier = "FeedTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with image:UIImage){
        contentImage.image = image
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "FeedTableViewCell", bundle: nil)
        
    }
}
