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

        if Auth.auth().currentUser != nil {
            userController.retrieveUser(uid: Auth.auth().currentUser!.uid){
                user in
                
                print("UID in database:" + user.uid)
                
                //Condition to check if database exist
                
                if(user.uid == ""){
                    self.firebaseController.getUserDataByUID(uid: Auth.auth().currentUser!.uid){
                        userFB in
                        
                        let userF = userFB
                        print("UID Retrieved from database:" + userF.uid)
                        
                        self.appDelegate.user = userF;
                        self.userController.AddUser(user: userF)
                        
                        self.firebaseController.getAllFavourites(uid: Auth.auth().currentUser!.uid){
                            favourtelist in
                            
                            self.appDelegate.user.favourite = favourtelist
                            
                            for place in favourtelist{
                                if(place.venueImage != "0"){
                                    self.downloaded(from: URL(string: place.venueImage)!){
                                    venueImage in
                                    
                                    place.venueImageData = venueImage;
                                    self.favouriteController.addFavouriteToUser(user: userF, place: place)
                                }
                                }else{
                                    place.venueImageData = #imageLiteral(resourceName: "noResult");
                                    self.favouriteController.addFavouriteToUser(user: userF, place: place)
                                }
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
                        
                        print("Loaded fav list in Controller: ", list.count)
                        
                        self.appDelegate.user = user;

                        self.appDelegate.user.favourite = list;

                        //We will need to request the favourite detailed place
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let nextViewController = storyBoard.instantiateInitialViewController()!
                        
                        nextViewController.modalPresentationStyle = .fullScreen
                        
                        self.present(nextViewController, animated:false, completion:nil)
                    }
                }
                
                
            }
        }
    }
    
    func downloaded(from url: URL, completionHandler:@escaping (_ postArray: UIImage)->Void) {
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                
                completionHandler(#imageLiteral(resourceName: "noResult"))
                
                return
            }
            
            completionHandler(UIImage(data: data)!)
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
}
