//
//  ProfileController.swift
//  EatWhatLah
//
//  Created by Ajaeson on 26/1/21.
//

import Foundation

import UIKit
import FirebaseAuth

class ProfileController: UIViewController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let firebase = FirebaseController()
    let screenWidth  = UIScreen.main.bounds.width - 30
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var ProfileContent: UICollectionView!
    
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileMobile: UILabel!
    
    @IBOutlet var biosTextView: UITextView!
    //let profile = ProfileModel.init()
    
    var listOfPost:[Post] = []
    
    @IBAction func logOutOnClick(_ sender: Any) {
        do {
            try Auth.auth().signOut();
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    //var pictures:[String] = ["Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers"]
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfPost = firebase.getAllPost(uid: appDelegate.user.uid)
        
        ProfileName.text = appDelegate.user.name
        ProfileMobile.text = appDelegate.user.email
        profilePicture.image = appDelegate.user.profilePicture
        
        if(appDelegate.user.bio != "0"){
        biosTextView.text = appDelegate.user.bio;
        }else{
            biosTextView.text = "Bio is not set"
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        ProfileContent.collectionViewLayout = layout
        ProfileContent.register(ProfileCollectionViewCell.nib(), forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        ProfileContent.delegate = self
        ProfileContent.dataSource = self
        
    }
}

extension ProfileController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print(indexPath)
    }
}
extension ProfileController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
        
        cell.configure(with: listOfPost[indexPath.row])
        return cell
    }
}

extension ProfileController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/3, height: screenWidth/3)
    }
}
