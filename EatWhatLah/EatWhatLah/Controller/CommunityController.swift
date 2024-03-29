//
//  CommunityController.swift
//  EatWhatLah
//
//  Created by Ajaeson on 21/1/21.
//

import Foundation
import UIKit

class CommunityController:UIViewController{
    //Outlets
    @IBOutlet var profilePicture:UIButton!
    @IBOutlet var atfCollectionView:UICollectionView!
    @IBOutlet var feedTableView:UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let firebase:FirebaseController = FirebaseController()
    //data
    var feedPost:[Post] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //set profile image
        profilePicture.setBackgroundImage(appDelegate.user.profilePicture, for: .normal)
        
        firebase.getAllPost{postRetrieve in
            
            self.feedPost = postRetrieve;
            
            self.feedTableView.reloadData()
            self.atfCollectionView.reloadData()
        }
        
        //initializing ATF
        atfCollectionView.register(ATFCollectionViewCell.nib(), forCellWithReuseIdentifier: ATFCollectionViewCell.identifier)
        
        atfCollectionView.delegate = self
        atfCollectionView.dataSource = self
        
        //initializing Feed
        feedTableView.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.identifier)
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }

    @IBAction func profilePicture(_ sender: Any) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        profileController.modalPresentationStyle = .fullScreen

        profileController.user = appDelegate.user
        self.present(profileController, animated: true)
    }
    
}

//ATF Controller
extension CommunityController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (feedPost.count > 10){
            return 10
        }
        else{
            print("idk:", feedPost.count)

            return feedPost.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = atfCollectionView.dequeueReusableCell(withReuseIdentifier: ATFCollectionViewCell.identifier, for: indexPath) as! ATFCollectionViewCell
        
        var atfList = feedPost
        atfList.sort(by: {$0.likes > $1.likes})
        if(indexPath.row < 10){
            cell.configure(with: atfList[indexPath.row])
            return cell
        }else{
            cell.configure(with: atfList[indexPath.row])
            return cell
        }
        
        
    }
    
}

//Feed Controller
extension CommunityController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return feedPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        cell.configure(with: feedPost[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        
        let storyBoard:UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ContentView") as! ContentController
        
        cell.configure(with: feedPost[indexPath.row])
        
        nextViewController.post = feedPost[indexPath.row]
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true, completion: nil)
    }
}

