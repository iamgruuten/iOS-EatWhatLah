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
import SwiftSpinner

class onBoardController:UIViewController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let userController:UserController = UserController();
    let firebaseController:FirebaseController = FirebaseController();
    let favouriteController:FavouriteController = FavouriteController();
    
    
    override func viewDidLoad() {
        print("UID Loaded:" + Auth.auth().currentUser!.uid)

        if Auth.auth().currentUser != nil {
            userController.retrieveUser(uid: Auth.auth().currentUser!.uid){
                user in
                
                print("UID in database:" + user.uid)
                
                //Condition to check if database exist
                
                if(user.uid == ""){
                    self.firebaseController.getUserData(uid: Auth.auth().currentUser!.uid){
                        userFB in
                        
                        let userF = userFB
                        print("UID Retrieved from database:" + userF.uid)
                        
                        self.appDelegate.user = userF;
                        self.userController.AddUser(user: userF)
                        
                        self.firebaseController.getAllFavourites(uid: Auth.auth().currentUser!.uid){
                            favourtelist in
                            
                            self.appDelegate.user.favourite = favourtelist
                            
                            for place in favourtelist{
                                self.favouriteController.addFavouriteToUser(user: userF, place: place)
                            }
                            
                            //Load into local database as well
                            
                            self.favouriteController.retrieveFavouriteByUID(uid: self.appDelegate.user.uid){
                                list in
                                self.appDelegate.user.favourite = list;
                                
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateInitialViewController()!
                                
                                nextViewController.modalPresentationStyle = .fullScreen
                                
                                self.present(nextViewController, animated:false, completion:nil)
                            }
                        }
                        
                    }
                }else{
                    self.favouriteController.retrieveFavouriteByUID(uid: self.appDelegate.user.uid){ list in
                        self.appDelegate.user = user;

                        self.appDelegate.user.favourite = list;

                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let nextViewController = storyBoard.instantiateInitialViewController()!
                        
                        nextViewController.modalPresentationStyle = .fullScreen
                        
                        self.present(nextViewController, animated:false, completion:nil)
                    }
                }
                
                
            }
        }
    }
}
