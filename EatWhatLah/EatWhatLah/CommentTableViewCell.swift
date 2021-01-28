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
    @IBOutlet var userComment:UITextView!
    
    static let identifier = "CommentTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func profilePicture(_ sender: Any) {
    }
    @IBAction func username(_ sender: Any) {
    }
    @IBAction func likeButton(_ sender: Any) {
        
    }
    
    public func configure(with image:UIImage, name:String, comment:String){
        profilePicture.setImage(image, for: .normal)
        username.setTitle(name, for: .normal)
        userComment.text = comment
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "CommentTableViewCell", bundle: nil)
        
    }
}
