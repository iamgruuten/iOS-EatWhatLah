//
//  FirebaseController.swift
//  EatWhatLah
//
//  Created by Apple on 29/1/21.
//


import FirebaseAuth
import Firebase
import FirebaseStorage
import CoreLocation


class FirebaseController{
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Get Post
    func getAllPost(uid:String, completionHandler:@escaping (_ postArray: [Post])->Void){
        //Init listPost
        var listOfPosts:[Post] = []
        print("UID: " + uid)
        let ref = Database.database().reference().child("posts").child(uid)
        
        print("Getting all post")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let postsByUser = snapshot.value as? NSDictionary
            
            if(postsByUser != nil){
                for post in postsByUser!{
                    var listOfComments:[Comment] = []
                    
                    let postObject:Post = Post();
                    let key:String = post.key as! String;
                    print("Post key = " + key)
                    let postDescription = post.value as? NSDictionary
                    
                    let postComments = postDescription!["allComments"] as? NSDictionary
                    
                    let postLikes = postDescription!["likes"] as? NSDictionary
                    
                    let urlLink = postDescription!["imageURL"] as! String
                    
                    let description = postDescription!["description"] as! String
                    
                    postObject.description = description
                    
                    postObject.postImageURL = URL(string: urlLink)
                    print(urlLink)
                    let storage = Storage.storage()
                    
                    let gsReference = storage.reference(forURL:postDescription?["imageURL"] as! String)
                    
                    gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                            print(error)
                        } else {
                            postObject.postImage = UIImage(data: data!)!
                            print("downloaded image")
                            
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
                            
                            print("Adding Key : " + key)
                            listOfPosts.append(postObject)
                            
                        }
                        completionHandler(listOfPosts)
                        
                    }
                }
                completionHandler(listOfPosts)
                
            }
        })
        
        print("return without waiting/")
    }
    
    func getAllPost(completionHandler:@escaping (_ postArray: [Post])->Void){
        //Init listPost
        var listOfPosts:[Post] = []
        let ref = Database.database().reference().child("posts")
        
        print("Getting all post")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let posts = snapshot.value as! NSDictionary
            
            for i in posts{
                let postsByUser = i.value as? NSDictionary
                
                for post in postsByUser!{
                    var listOfComments:[Comment] = []
                    
                    let postObject:Post = Post();
                    
                    let key:String = post.key as! String;
                    print("Post key = " + key)
                    let postDescription = post.value as? NSDictionary
                    
                    let postComments = postDescription!["allComments"] as? NSDictionary
                    
                    let postLikes = postDescription!["likes"] as? NSDictionary
                    
                    let urlLink = postDescription!["imageURL"] as! String
                    
                    let description = postDescription!["description"] as! String
                    
                    postObject.description = description
                    
                    postObject.postImageURL = URL(string: urlLink)
                    print(urlLink)
                    let storage = Storage.storage()
                    
                    let gsReference = storage.reference(forURL:postDescription?["imageURL"] as! String)
                    
                    gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                            print(error)
                        } else {
                            postObject.postImage = UIImage(data: data!)!
                            print("downloaded image")
                            
                            for comment in postComments!{
                                var likers:[String] = [];
                                
                                let commentObj:Comment = Comment();
                                let commentsListFB = comment.value as? NSDictionary;
                                
                                commentObj.commentID = comment.key as? String;
                                commentObj.comment = commentsListFB?["comment"] as? String;
                                commentObj.commentor = commentsListFB?["userID"] as? String;
                                
                                //Calculate how liked my comment
                                let commentList = commentsListFB!["likes"] as? NSDictionary
                                
                                if(commentList != nil){
                                    for uidLiker in (commentList!){
                                        let likerUID:String = uidLiker.value as! String
                                        likers.append(likerUID)
                                    }
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
                            
                            print("Adding Key : " + key)
                            listOfPosts.append(postObject)
                            
                        }
                        listOfPosts.sort(by: {$0.likes > $1.likes})
                        completionHandler(listOfPosts)

                    }
                    
                }
            }
        })
        
        print("return without waiting/")
    }
    
    
    //Add Post
    func addPost(uid:String, image:UIImage, description:String){
        //Upload image to google storage
        
        let storage = Storage.storage(url:"gs://eatwhatlah-d17f2.appspot.com")
        
        let storageRef = storage.reference()
        
        let folderRef = storageRef.child("posts").child(uid)
        
        // Collect data from imageView
        let data = image.pngData()
                
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        // Create a reference to the profile image upload
        let imageRef = folderRef
        
        // Upload the file to the path
        let uploadTask = imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            print(size)
            
            imageRef.downloadURL {
                
                (url, error) in
                if url != nil{
                    //No Error
                    let ref = Database.database().reference()
                    
                    ref.child("posts").child(uid).updateChildValues(
                        ["profileURL":url?.absoluteString as Any]
                    )
                    
                } else {
                    //Error
                }
            }
        }
        
        
        
        uploadTask.observe(.success) { snapshot in
            
            
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
        }
        }
    }
    
    //Add Likes
    
    
    //Add Comment to post
    
    
    //Get Favourites
    func getAllFavourites(uid:String, completionHandler:@escaping (_ postArray: [Places])->Void){
        
        //Init list
        var listOfPlaces:[Places] = [];
        
        //Retrieve user data
        let ref = Database.database().reference().child("favourite").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let favouritePlaces = snapshot.value as? NSDictionary
            
            if(favouritePlaces != nil){
                
                for place in favouritePlaces!{
                    let placeObject:Places = Places();
                    let key:String = place.key as! String;
                    
                    placeObject.place_id = key
                    
                    let placeDescription = place.value as? NSDictionary
                    
                    placeObject.lat = placeDescription!["lat"] as! String
                    placeObject.venueName = placeDescription!["VenueName"] as! String
                    placeObject.long = placeDescription!["lng"] as! String
                    placeObject.distance = self.appDelegate.getDistance(lat: placeObject.lat, long: placeObject.long)
                    
                    let dataImage = placeDescription!["imageUrl"] as! String
                    
                    placeObject.venueImage = dataImage;
                    placeObject.venueAddress = placeDescription!["Address"] as! String
                    print("Adding Key : " + key)
                    listOfPlaces.append(placeObject)
                }
            }
            
            completionHandler(listOfPlaces)
        })
    }
    
    //Add Favourite
    func addFavourite(uid:String, place:Places) {
        //Retrieve user data
        let ref = Database.database().reference()
        print(uid)
        ref.child("favourite").child(uid).child(place.place_id).updateChildValues(
            [
                "placeID":place.place_id,
                "lat":place.lat,
                "lng":place.long,
                "VenueName":place.venueName,
                "Address":place.venueAddress,
                "imageUrl":place.venueImage
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
    func getUserData(uid:String, completionHandler:@escaping (_ postArray: User)->Void){
        
        //Init
        let userObject:User = User();
        
        //Retrieve user data
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDetails = snapshot.value as? NSDictionary
            userObject.bio = userDetails!["Bio"] as! String
            userObject.email = userDetails!["Email"] as! String
            userObject.name = userDetails!["Name"] as! String
            userObject.preference = userDetails!["Preference"] as! String
            userObject.uid = snapshot.key;
            let storage = Storage.storage()
            
            let gsReference = storage.reference(forURL:userDetails?["profileURL"] as! String)
            
            gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error)
                } else {
                    userObject.profilePicture = UIImage(data: data!)!
                    completionHandler(userObject)
                    
                }
            }
        })
        
    }
    
}
