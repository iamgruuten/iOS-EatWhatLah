//
//  FavouriteController.swift
//
//  Created by Apple on 04/01/20.
//
// The purpose to limit the need of retrieving data from firebase multiple of times for data usage

import CoreData
import UIKit

class UserController{
    
    var appDelegate:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var context:NSManagedObjectContext
    var favouriteController:FavouriteController = FavouriteController();
    
    init() {
        context = appDelegate.persistentContainer.viewContext
    }
    
    func AddUser(user:User){
                
        do{
            //Check if user exist before creating new row
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDUserModel")
            
            fetchRequest.predicate = NSPredicate(format: "uid = %@", user.uid)
        
            let results = try context.fetch(fetchRequest)
            if results.count == 0 {
                
                //add Users
                let entityUser = NSEntityDescription.entity(forEntityName: "CDUserModel", in: context)
                
                let userObject = NSManagedObject(entity: entityUser!, insertInto: context) as! CDUserModel
                
                userObject.name = user.name;
                userObject.email = user.email;
                userObject.bio = user.bio;
                userObject.uid = user.uid;
                userObject.locked = user.locked;

                //Profile Image
                let data = (user.profilePicture).pngData()
                
                userObject.image = data;
                
                
                try context.save()
                
                print("saved record, added")

            }else{
                print("duplicate record, therefore not added")
            }
        }catch let error as NSError{
            print(error)
        }

    }
    
    
    func retrieveUser(uid:String, completionHandler:@escaping (_ postArray: User)->Void){
        
        let user:User = User();
        do{
            //Check if user exist before creating new row
            print("Loading Users...")

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDUserModel")
            
            fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)
        
            let results = try context.fetch(fetchRequest)
            print("Account is ", results.count)

            if results.count != 0 {
                let userObject = results[0] as! CDUserModel;
                user.name = userObject.name!;
                user.uid = userObject.uid!;
                user.bio = userObject.bio!;
                user.locked = userObject.locked;
                user.email = userObject.email!;
                user.profilePicture = UIImage(data: userObject.image!)!
                
                favouriteController.retrieveFavouriteByUID(uid: user.uid){
                    favList in
                    print("Loaded Users...")

                    user.favourite = favList
                    completionHandler(user)

                }

            }
            
            completionHandler(user)
            
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    func updateUser(name:String, bio:String, uid:String, locked:Bool){
                
        do{
            //Check if user exist before creating new row
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDUserModel")
            
            fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)
        
            let results = try context.fetch(fetchRequest)
            if results.count != 0 {
                
                //update Users
                let entityVenue = results[0] as! CDUserModel
                
                entityVenue.name = name;
                entityVenue.bio = bio;
                entityVenue.locked = locked;
                try context.save()
                
                print("saved record, added")

            }else{
                print("duplicate record, therefore not added")
            }
        }catch let error as NSError{
            print(error)
        }

    }
}
