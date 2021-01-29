//
//  FirebaseController.swift
//  EatWhatLah
//
//  Created by Apple on 29/1/21.
//


import FirebaseAuth
import Firebase
import FirebaseStorage

class FirebaseController{
    

//Get Post
    
    
//Add Post
    
    
//Add Likes
    
    
//Add Comment to post


//Get Favourites
    func getFavourites(uid:String) {
        //Retrieve user data
        let ref = Database.database().reference().child("favourite").child(uid)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let userDetails = snapshot.value as? NSDictionary
            
      })
}

//Add Favourite
    func addFavourite(uid:String, place:Result) {
        //Retrieve user data
        let ref = Database.database().reference().child("favourite").child(uid)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let userDetails = snapshot.value as? NSDictionary
                let storage = Storage.storage()

                let gsReference = storage.reference(forURL:userDetails?["profileURL"] as! String)
                                    
      })
}
    
//Remove Favourite
    func removeFavourite(uid:String, place:Result) {
        //Retrieve user data
        let ref = Database.database().reference().child("favourite").child(uid)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let userDetails = snapshot.value as? NSDictionary
                let storage = Storage.storage()

                let gsReference = storage.reference(forURL:userDetails?["profileURL"] as! String)
                                    
      })
}

//Get User Details
}
