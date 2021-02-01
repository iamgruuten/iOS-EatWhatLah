//
//  user.swift
//  EatWhatLah
//
//  Created by Apple on 21/1/21.
//


import UIKit

class User{
    var name:String = "";
    var bio:String = "";
    var favourite:[Places] = [];
    var email:String = "";
    var uid:String = "";
    var password:String = "";
    var profilePicture:UIImage = UIImage();
    var preference:String = ""
    var posts:[Post]!
    var locked:Bool = false;
    
    init(){
        name = "";
        uid = "";
        bio = "";
        favourite = [];
        email = "";
        password = "";
    }
    
}

