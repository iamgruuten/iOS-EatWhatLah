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
    
    @IBOutlet var logOut:UIButton!
    @IBOutlet var edit:UIButton!
    //let profile = ProfileModel.init()
    var user:User!
    var listOfPost:[Post] = []
    
    @IBAction func logOutOnClick(_ sender: Any) {
        do {
            try Auth.auth().signOut();
            
            let mainStoryboard = UIStoryboard(name: "onboard", bundle: nil)
            
            let onBoardController = mainStoryboard.instantiateInitialViewController()
            
            onBoardController!.modalPresentationStyle = .fullScreen
            
            self.present(onBoardController!, animated: false)
            
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    //var pictures:[String] = ["Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers"]
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool){
        if(user == nil){
        ProfileName.text = appDelegate.user.name
        ProfileMobile.text = appDelegate.user.email
        profilePicture.image = appDelegate.user.profilePicture
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()

        if (user != nil){
            logOut.isHidden = true
            edit.isHidden = true
            
        }
        else{
            logOut.isHidden = false
            edit.isHidden = false
            user = appDelegate.user
        }
        
        
        firebase.getAllPost(uid: user.uid) { postRetrieve in
            self.listOfPost = postRetrieve
            self.ProfileContent.reloadData()
        }
        
        ProfileName.text = user.name
        ProfileMobile.text = user.email
        profilePicture.image = user.profilePicture
        
        if(user.bio != "0"){
            biosTextView.text = user.bio;
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
        
        let storyBoard:UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ContentView") as! ContentController
        
        nextViewController.post = cell.lpost
        
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true, completion: nil)
    }
}
extension ProfileController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(listOfPost.count)
        return listOfPost.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
        
        if listOfPost.count > 0 {
            cell.configure(with: listOfPost[indexPath.row])
            return cell
        }
        else{
            return cell
        }
    }
}

extension ProfileController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/3, height: screenWidth/3)
    }
}
