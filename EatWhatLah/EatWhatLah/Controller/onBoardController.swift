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

    override func viewDidLoad() {
        if Auth.auth().currentUser != nil {
            appDelegate.user = userController.retrieveUser(uid: Auth.auth().currentUser!.uid)
            print(Auth.auth().currentUser!.uid)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateInitialViewController()!
            
            nextViewController.modalPresentationStyle = .fullScreen
            
            self.present(nextViewController, animated:false, completion:nil)
        }
    }
}
