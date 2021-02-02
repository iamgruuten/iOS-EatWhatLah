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
        
    var lpost:Post!
    static let identifier = "FeedTableViewCell"
    let firebase = FirebaseController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    public func configure(with post:Post){
        lpost = post
        contentImage.image = post.postImage
        userImage.image = post.postUserImage
//        username.setTitle(post.postUser, for: .normal)
//        username.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        
        firebase.getUserNameByUID(uid: lpost.postUserID){
            name in
            
            let Username = NSAttributedString(string:
                name
                ,
                attributes: [
                    NSAttributedString.Key.strokeColor: UIColor.black,
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.strokeWidth: -2.0,
                    NSAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 15)
                ]
            )
            
            self.username.setAttributedTitle(Username, for: .normal)
        }
        
        if post.allComment.count != 0{
            topComment.text = post.allComment[0].comment
            firebase.getUserNameByUID(uid: post.allComment[0].commentor){usernameHandler in
                self.comUser.text = usernameHandler
            }
            topComment.textColor = UIColor(hex: "#FFFFFF")
        }
        else{
            topComment.text = "Come and comment leh~"
            topComment.textColor = UIColor(hex: "#FFFFFF")
        }
        
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "FeedTableViewCell", bundle: nil)
        
    }
    
    @IBAction func username(_ sender: Any) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        profileController.modalPresentationStyle = .fullScreen
        
        firebase.getUserDataByUID(uid: lpost.postUserID){userRetrieve in
            profileController.user = userRetrieve
        }
        self.window?.rootViewController?.present(profileController, animated: true)
    }
}
