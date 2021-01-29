//
//  Post.swift
//  EatWhatLah
//
//  Created by Ajaeson on 29/1/21.
//

import Foundation
import UIKit

class Post{
    var postID:String!
    var postUser:String!
    var postUserImage:UIImage!
    var postImage:UIImage!
    var topComUser:String!
    var topComment:String!
    var allComment:[Comment]!
    var likes:Int!
    var location:Places!
    
    init(pUsername:String,pUserImage:UIImage,pImage:UIImage,topCommentUser:String,TopCom:String){
        postUser = pUsername
        postUserImage = pUserImage
        postImage = pImage
        topComUser = topCommentUser
        topComment = TopCom
        //allComment = AllComment
        //likes = Likes
        //location = Location
    }
    
    init(){}
}

