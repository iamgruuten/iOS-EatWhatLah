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
    
    var postLocal:Post!
    var commentLocal:Comment!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let firebase = FirebaseController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func profilePicture(_ sender: Any) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        profileController.modalPresentationStyle = .fullScreen
        
        firebase.getUserDataByUID(uid: postLocal.postUserID){userRetrieve in
            profileController.user = userRetrieve
        }
        self.window?.rootViewController?.present(profileController, animated: true)
    }
    
    @IBAction func username(_ sender: Any) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        profileController.modalPresentationStyle = .fullScreen
        
        firebase.getUserDataByUID(uid: postLocal.postUserID){userRetrieve in
            profileController.user = userRetrieve
        }
        
        self.window?.rootViewController?.present(profileController, animated: true)
    }
    @IBAction func likeButton(_ sender: Any) {
        if !(commentLocal.userWhoLiked.contains(appDelegate.user.uid)){
            firebase.addLikesToComment(postID: postLocal.postID, likerUserUID: appDelegate.user.uid, postUserUID: postLocal.postUserID, commentID: commentLocal.commentID)
            
            likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        }
        else{
            firebase.removeLikesFromComments(postID: postLocal.postID, likerUserUID: appDelegate.user.uid, postUserUID: postLocal.postUserID, commentID: commentLocal.commentID)
            
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    public func configure(with comment:Comment, post:Post){
        commentLocal = comment
        firebase.getUserDataByUID(uid: comment.commentor){userRetrieve in
            self.username.setTitle(userRetrieve.name, for: .normal)
        }
        userComment.text = comment.comment
        if (comment.userWhoLiked.contains(appDelegate.user.uid)){
            likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        }
        else{
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "CommentTableViewCell", bundle: nil)
        
    }
}
