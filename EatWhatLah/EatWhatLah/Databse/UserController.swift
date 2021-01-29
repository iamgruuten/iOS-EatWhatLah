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
                let entityVenue = NSEntityDescription.entity(forEntityName: "CDUserModel", in: context)
                
                let userObject = NSManagedObject(entity: entityVenue!, insertInto: context) as! CDUserModel
                
                userObject.name = user.name;
                userObject.email = user.email;
                userObject.bio = user.bio;
                userObject.uid = user.uid;
                
                //Profile Image
                let data = (user.profilePicture).pngData()
                
                userObject.image = data;
                
                
                try context.save()
            }else{
                print("duplicate record, therefore not added")
            }
        }catch let error as NSError{
            print(error)
        }

    }
    
    
    func retrieveUser(uid:String)->User{
        
        let user:User = User();
        do{
            //Check if user exist before creating new row
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDUserModel")
            
            fetchRequest.predicate = NSPredicate(format: "uid = %@", uid)
        
            let results = try context.fetch(fetchRequest)
            
            if results.count != 0 {
                let userObject = results[0] as! CDUserModel;
                user.name = userObject.name!;
                user.bio = userObject.bio!;
                user.favourite = favouriteController.retrieveFavouriteByUID(uid: <#T##String#>)(uid: user.uid)
                user.email = userObject.email!;
                user.profilePicture = UIImage(data: userObject.image!)!

            }else{
                print("duplicate record, therefore not added")
            }
        }catch let error as NSError{
            print(error)
        }
        
        return user;
    }
}
