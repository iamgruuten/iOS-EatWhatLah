//
//  PostController.swift
//  EatWhatLah
//
//  Created by Ajaeson on 29/1/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class PostController {
    var commentController:CommentController = CommentController();
    
    func retrievePostsByUserId(userID:String) -> [Post]{
        let ref = Database.database().reference().child("posts").child(userID)
        let post = Post.init()
        var postList = [post]
        return postList
    }
    
}
