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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //Get Post
    func getAllPost(uid:String)->[Post]{
     //Init listPost
        var listOfPosts:[Post] = []
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let postsByUser = snapshot.value as? NSDictionary
            
            for post in postsByUser!{
                var listOfComments:[Comment] = []

                let postObject:Post = Post();
                let key:String = post.key as! String;
                
                let postDescription = post.value as? NSDictionary

                let postComments = postDescription!["allComments"] as? NSDictionary
                
                let postLikes = postDescription!["likes"] as? NSDictionary
                
                let urlLink = postDescription!["imageURL"] as! String
                
                postObject.postImageURL = URL(string: urlLink)
                
                
                for comment in postComments!{
                    var likers:[String] = [];
                    
                    let commentObj:Comment = Comment();
                    let commentsListFB = comment.value as? NSDictionary;
                    
                    commentObj.commentID = comment.key as? String;
                    commentObj.comment = commentsListFB?["comment"] as? String;
                    commentObj.commentor = commentsListFB?["userID"] as? String;
                    
                    //Calculate how liked my comment
                    for uidLiker in (commentsListFB!["likes"] as? NSDictionary)!{
                        let likerUID:String = uidLiker.value as! String
                        likers.append(likerUID)
                    }
                    
                    commentObj.userWhoLiked = likers;
                    commentObj.likes = likers.count;
                    
                    listOfComments.append(commentObj)
                    
                }
                
                postObject.allComment = listOfComments
                
                var likers:[String] = [];

                for like in postLikes!{
                    let likerUID:String = like.value as! String
                    likers.append(likerUID)
                }
                
                postObject.usersWhoLiked = likers;
                postObject.likes = likers.count;
                postObject.postID = key;
                postObject.postUser = self.appDelegate.user.name;
                postObject.postImage = self.appDelegate.user.profilePicture;
                
                print("Adding Key : " + key)
                listOfPosts.append(postObject)
            }
            
        })
        
        return listOfPosts
    }
    
    
    //Add Post
    
    
    //Add Likes
    
    
    //Add Comment to post
    
    
    //Get Favourites
    func getAllFavourites(uid:String)->[Places]{
        
        //Init list
        var listOfPlaces:[Places] = [];
        
        //Retrieve user data
        let ref = Database.database().reference().child("favourite").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let favouritePlaces = snapshot.value as? NSDictionary
            
            for place in favouritePlaces!{
                let placeObject:Places = Places();
                let key:String = place.key as! String;
                
                placeObject.place_id = key
                
                let placeDescription = place.value as? NSDictionary
                
                placeObject.lat = placeDescription!["lat"] as! String
                placeObject.venueName = placeDescription!["VenueName"] as! String
                placeObject.long = placeDescription!["lng"] as! String
                placeObject.venueImageData = placeDescription!["ImageData"] as! Data
                
                print("Adding Key : " + key)
                listOfPlaces.append(placeObject)
            }
        })
        
        return listOfPlaces;
        
    }
    
    //Add Favourite
    func addFavourite(uid:String, place:Places) {
        //Retrieve user data
        let ref = Database.database().reference().child("favourite").child(uid)
        
        ref.child("favourite").child(uid).child(place.place_id).updateChildValues(
            ["lat":place.lat,
             "lng":place.long,
             "VenueName":place.venueName,
             "ImageData":place.venueImageData
            ]
        )
    }
    
    //Remove Favourite
    func removeFavourite(uid:String, place_id:String) {
        //Retrieve user data
        let ref = Database.database().reference().child("favourite").child(uid)
        ref.child("favourite").child(uid).child(place_id).removeValue();
        
    }
    
    //Get User Details
}
