//
//  Comment.swift
//  EatWhatLah
//
//  Created by Ajaeson on 29/1/21.
//

import Foundation

class Comment{
    var comment:String!
    var commentor:String!
    var likes:Int!
    var userWhoLiked:[String]!
    
    init(){}
    
    init(Comment:String,Commentor:String!,Likes:Int,UserWhoLiked:[String]) {
        comment = Comment
        commentor = Commentor
        likes = Likes
        userWhoLiked = UserWhoLiked
    }
    
}
