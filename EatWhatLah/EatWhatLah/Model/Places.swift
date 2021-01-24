//
//  Places.swift
//  EatWhatLah
//
//  Created by Apple on 24/1/21.
//

import UIKit

class Places{
    var venueName:String = "";
    var rating:Double = 0;
    var venueImage:UIImage = UIImage();
    var distance:Double = 0;
    
    init(venueName:String, rating:Double, venueImage:UIImage, distance:Double) {
        self.venueName = venueName;
        self.rating = rating;
        self.venueImage = venueImage;
        self.distance = distance;
    }
    
}
