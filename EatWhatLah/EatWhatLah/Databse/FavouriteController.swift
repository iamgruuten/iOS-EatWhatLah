//
//  FavouriteController.swift
//
//  Created by Apple on 04/01/20.
//

import CoreData
import UIKit

class FavouriteController{
    
    var appDelegate:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var context:NSManagedObjectContext
    
    
    init() {
        context = appDelegate.persistentContainer.viewContext
    }
    
    //Add favourite venue with date and time
    func AddFavouritePlace(place:Places)->CDSavedLocation{
        //Check if location exist before creating new row
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDSavedLocation")
        
        fetchRequest.predicate = NSPredicate(format: "placeID = %@", place.place_id)
        
        
        //Add place since dont have
        let entityVenue = NSEntityDescription.entity(forEntityName: "CDSavedLocation", in: context)
        
        let placeObject = NSManagedObject(entity: entityVenue!, insertInto: context) as! CDSavedLocation
        
        do{
            placeObject.venueName = place.venueName;
            placeObject.placeID = place.place_id;
            placeObject.lat = place.lat;
            placeObject.long = place.long;
            placeObject.distance = place.distance;
            placeObject.rating = place.rating;
            
            try context.save()
            
            
        }catch let error as NSError{
            print(error)
        }
        
        return placeObject
    }
    
    //Add user to place - Many to Many
    func addFavouriteToUser(user:User, place:Places) {
        
        //check if got duplicate, so that can be reused to link to place
        let fetchVenueRequest = NSFetchRequest<CDSavedLocation>(entityName: "CDSavedLocation")
        
        fetchVenueRequest.predicate = NSPredicate(format: "PlaceID = %@", place.place_id)
        
        do{
            let cdVenue = try context.fetch(fetchVenueRequest)
            
            //Get user object to add the favourite in
            
            let fetchRequest = NSFetchRequest<CDUserModel>(entityName: "CDUserModel")
            fetchRequest.predicate = NSPredicate(format: "uid = %@", user.uid)
            
            let cdUser = try context.fetch(fetchRequest)
            let userObject = cdUser[0]
            
            if cdVenue.count > 0{
                
                let venue = cdVenue[0]
                venue.addToUserID(userObject)
                
            }else{
                print("Error Not Venue Found")
                let placeObject = AddFavouritePlace(place: place)
                placeObject.addToUserID(userObject)
            }
            try context.save()
            
        }catch let error as NSError{
            print(error)
        }
    }
    
    //retrieve favourite places
    func retrieveFavouritePlaces() -> [Places] {
        var favouriteList:[Places] = [Places]();
        
        let fetchRequestVenue = NSFetchRequest<CDUserModel>(entityName:"CDUserModel")
        
        do{
            
            let CDFavouriteList = try context.fetch(fetchRequestVenue);
            
            if(CDFavouriteList.count > 0){
                for item in CDFavouriteList {
                    
                    let user:User = User();
                    
                    user.uid = item.uid!
                    
                    let favourites = item.savedLocations as! Set<CDSavedLocation>;
                    
                    for favourite in favourites{
                        
                        let place:Places = Places();
                        place.distance = favourite.distance;
                        place.lat = favourite.lat!;
                        place.long = favourite.long!;
                        place.place_id = favourite.placeID!;
                        place.rating = favourite.rating!;
                        place.venueName = favourite.venueName!;
                        
                        favouriteList.append(place)
                    }
                }
            }
            
            
        }catch let error as NSError{
            print(error)
        }
        
        return favouriteList
    }
    
    //retrieve ingredients based on title
    func retrieveIngredientsbyName(uid:String) -> [Places]{
        var favouriteListUser:[Places] = [Places]();
        
        let fetchRequestUser = NSFetchRequest<CDUserModel>(entityName:"CDUserModel")
        
        do{
            fetchRequestUser.predicate = NSPredicate(format: "uid = %@", uid)
            let userObject = try context.fetch(fetchRequestUser);
            
            if(userObject.count > 0){
                
                let favouriteList = userObject.first!.savedLocations as! Set<CDSavedLocation>;
                
                for favourite in favouriteList{
                    let place:Places = Places();
                    place.distance = favourite.distance;
                    place.lat = favourite.lat!;
                    place.long = favourite.long!;
                    place.place_id = favourite.placeID!;
                    place.rating = favourite.rating!;
                    place.venueName = favourite.venueName!;
                    
                    favouriteListUser.append(place)
                    
                }
                
            }
            
        }catch let error as NSError{
            print(error)
        }
        
        return favouriteListUser;
    }
    
    
}

