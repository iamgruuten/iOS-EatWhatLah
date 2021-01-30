//
//  onBoardController.swift
//  EatWhatLah
//
//  Created by Apple on 29/1/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftSpinner
import CoreLocation

class onBoardController:UIViewController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let userController:UserController = UserController();
    let firebaseController:FirebaseController = FirebaseController();
    
    override func viewDidLoad() {
                
        if Auth.auth().currentUser != nil {
            var user = userController.retrieveUser(uid: Auth.auth().currentUser!.uid)
            if(user.uid == ""){
                //Means not inside database
                user = firebaseController.getUserData(uid:  Auth.auth().currentUser!.uid)
            }
            
            appDelegate.user = user;
            
            print(Auth.auth().currentUser!.uid)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateInitialViewController()!
            
            nextViewController.modalPresentationStyle = .fullScreen
            
            self.present(nextViewController, animated:false, completion:nil)
                
        }
    }
}
