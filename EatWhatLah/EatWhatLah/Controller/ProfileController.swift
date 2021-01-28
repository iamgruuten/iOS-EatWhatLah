//
//  ProfileController.swift
//  EatWhatLah
//
//  Created by Ajaeson on 26/1/21.
//

import Foundation

import UIKit

class ProfileController: UIViewController{
    let screenWidth  = UIScreen.main.bounds.width - 20
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var ProfileContent: UICollectionView!
    
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileMobile: UILabel!
    
    //let profile = ProfileModel.init()
    
    var pictures:[String] = ["Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers","Burgers"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileName.text = "Burger Man"
        ProfileMobile.text = "999"
        profilePicture.image = UIImage.init(named: "user")
        
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
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
        
        cell.configure(with: UIImage(named: pictures[indexPath.row])!)
        return cell
    }
}

extension ProfileController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/3, height: screenWidth/3)
    }
}
