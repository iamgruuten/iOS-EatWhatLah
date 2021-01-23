//
//  user.swift
//  EatWhatLah
//
//  Created by Apple on 21/1/21.
//


import UIKit

class User{
    var name:String;
    var bio:String;
    var favourite:[String];
    var email:String;
    var uid:String;
    var password:String;
    var profilePicture:UIImage = UIImage();
    
    init(){
        name = "";
        uid = "";
        bio = "";
        favourite = [];
        email = "";
        password = "";
    }
}

