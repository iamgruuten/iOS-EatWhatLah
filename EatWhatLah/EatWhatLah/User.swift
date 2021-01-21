//
//  user.swift
//  EatWhatLah
//
//  Created by Apple on 21/1/21.
//


import UIKit

class User{
    var name:String;
    var favourite:[String];
    var email:String;
    var profilePicture:UIImage = UIImage();
    
    init(){
        name = "";
        favourite = [];
        email = "";
    }
}

