//
//  ContentController.swift
//  EatWhatLah
//
//  Created by Ajaeson on 28/1/21.
//

import Foundation
import UIKit
class ContentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var contentImage:UIImageView!
    @IBOutlet var contentDescription:UITextView!
    @IBOutlet var commentTableView:UITableView!
    @IBOutlet var ownerUsername:UIButton!
    @IBOutlet var profileButton:UIButton!
    @IBOutlet var commentField:UITextField!
    @IBOutlet var likeButton:UIButton!
    
    var post:Post!
    var user:User!
    
    let firebase = FirebaseController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        ownerUsername.setTitle(post.postUser, for: .normal)
        commentTableView.register(CommentTableViewCell.nib(), forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        contentImage.image = post.postImage
        contentDescription.text = post.description
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        if (post.usersWhoLiked.contains(appDelegate.user.uid)){
            likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        }
        else{
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    @IBAction func submitPost(_ sender: Any) {
        firebase.addCommentToPost(postID: post.postID, commentorID: appDelegate.user.uid, postUserUID: post.postUser, comment: commentField.text!)
    }
    
    //Table Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.allComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        
        cell.configure(with: post.allComment[indexPath.row], post: post)
        
        return cell
    }
    
    //Button
    @IBAction func ownerUsername(_ sender: Any) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        profileController.modalPresentationStyle = .fullScreen
        
        firebase.getUserDataByUID(uid: post.postUserID){userRetrieve in
            self.user = userRetrieve
        }
        profileController.user = user
        self.present(profileController, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        profileController.modalPresentationStyle = .fullScreen

        profileController.user = appDelegate.user
        self.present(profileController, animated: true)
    }
    
    @IBAction func navigationButton(_ sender: Any) {
    }
    @IBAction func likeButton(_ sender: Any) {
        if !(post.usersWhoLiked.contains(appDelegate.user.uid)){
            firebase.addLikeToPost(postID: post.postID, postUserUID: post.postUserID, likerUserUID: appDelegate.user.uid)
            
            likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        }else{
            firebase.removeLikesFromPost(postID: post.postID, postUserUID: post.postUserID, likerUserUID: appDelegate.user.uid)
            
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
}
