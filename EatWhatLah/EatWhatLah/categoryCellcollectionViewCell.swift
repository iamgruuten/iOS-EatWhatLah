//
//  categoryCellcollectionViewCell.swift
//  EatWhatLah
//
//  Created by Apple on 28/1/21.
//

import UIKit

class categoryCellcollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageCategory: UIImageView!
    @IBOutlet var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(name:String, image:UIImage){
        categoryNameLabel.text = name;
        imageCategory.image = image;
        
    }
    class var reuseIdentifier: String {
        return "categoryCell"
    }
}

