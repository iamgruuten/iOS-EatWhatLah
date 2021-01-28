//
//  PostTableViewCell.swift
//  EatWhatLah
//
//  Created by Ajaeson on 28/1/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet var username:UIButton!
    @IBOutlet var profilePicture:UIButton!
    @IBOutlet var likeButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
