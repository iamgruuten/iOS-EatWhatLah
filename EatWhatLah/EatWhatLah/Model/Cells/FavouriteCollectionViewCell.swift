//
//  FavouriteCollectionViewCell.swift
//  EatWhatLah
//
//  Created by Apple on 30/1/21.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var cell: UIView!
    @IBOutlet var imageCategory: UIImageView!
    @IBOutlet var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(name:String, image:UIImage, color:UIColor){
        categoryNameLabel.text = name;
        imageCategory.image = image;
        cell.backgroundColor = color;
        
    }
    class var reuseIdentifier: String {
        return "categoryCell"
    }
}

