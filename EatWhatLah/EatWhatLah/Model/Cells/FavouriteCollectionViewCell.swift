//
//  FavouriteCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Apple on 30/1/21.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(name:String){
    }
    
    class var reuseIdentifier: String {
        return "favouriteCell"
    }
}

