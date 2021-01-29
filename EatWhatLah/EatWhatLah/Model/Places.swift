//
//  Places.swift
//  EatWhatLah
//
//  Created by Apple on 24/1/21.
//

import UIKit

class Places{
    var venueName:String = "";
    var rating:String = "";
    var venueImage:String = "";
    var venueImageData:UIImage = UIImage();
    var distance:Double = 0;
    var lat:String = "";
    var long:String = "";
    var place_id:String = "";
    var open:String = "";
    var close:String = ""
    var popularity:Int = 0;
    
    
    init(venueName:String, rating:String, venueImage:String, distance:Double, place_id:String) {
        self.venueName = venueName;
        self.rating = rating;
        self.venueImage = venueImage;
        self.distance = distance;
        self.place_id = place_id;
    }
    
    init(){
        
    }
    
}
