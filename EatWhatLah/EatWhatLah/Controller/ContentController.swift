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
    var post:Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownerUsername.setTitle(post.postUser, for: .normal)
        commentTableView.register(CommentTableViewCell.nib(), forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        contentImage.image = post.postImage
        contentDescription.text = post.description
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }
    
    @IBAction func submitPost(_ sender: Any) {
        
    }
    
    //Table Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.allComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        
        cell.configure(with: post.allComment[indexPath.row])
        
        return cell
    }
    
    //Button
    @IBAction func ownerUsername(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileButton(_ sender: Any) {
    }
    @IBAction func navigationButton(_ sender: Any) {
    }
    @IBAction func likeButton(_ sender: Any) {
    }
    
}
