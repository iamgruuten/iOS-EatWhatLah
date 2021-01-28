//
//  FeedTableViewCell.swift
//  EatWhatLah
//
//  Created by Ajaeson on 28/1/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet var contentImage:UIImageView!
    @IBOutlet var userImage:UIImageView!
    @IBOutlet var username:UIButton!
    @IBOutlet var comUser:UILabel!
    @IBOutlet var topComment:UILabel!
    
    static let identifier = "FeedTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with post:Post){
        contentImage.image = post.postImage
        userImage.image = post.postUserImage
        username.setTitle(post.postUser, for: .normal)
        username.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        comUser.text = post.topComUser
        topComment.text = post.topComment
        topComment.textColor = UIColor(hex: "#FFFFFF")
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "FeedTableViewCell", bundle: nil)
        
    }
}
