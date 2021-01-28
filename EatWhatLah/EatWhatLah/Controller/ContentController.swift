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

    
    var allComment:[String] = ["This is a comment","This is the second comment","This is the last comment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownerUsername.setTitle("Jason", for: .normal)
        commentTableView.register(CommentTableViewCell.nib(), forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        contentImage.image = UIImage(named: "Burgers")
        contentDescription.text = "This is a very long paragraph of text to describe the image above. In order to save time I am going to start spamming this text with copypaste of the same paragraph. This is a very long paragraph of text to describe the image above. In order to save time I am going to start spamming this text with copypaste of the same paragraph. This is a very long paragraph of text to describe the image above. In order to save time I am going to start spamming this text with copypaste of the same paragraph."
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }
    
    //Table Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        
        cell.configure(with: UIImage(named: "user")!, name: "Jason", comment: allComment[indexPath.row])
        
        return cell
    }
    
    //Button
    @IBAction func ownerUsername(_ sender: Any) {
    }
    @IBAction func backButton(_ sender: Any) {
    }
    @IBAction func profileButton(_ sender: Any) {
    }
    @IBAction func navigationButton(_ sender: Any) {
    }
    @IBAction func likeButton(_ sender: Any) {
    }
    
}
