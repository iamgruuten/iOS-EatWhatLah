//
//  ExploreController.swift
//  EatWhatLah
//
//  Created by Apple on 23/1/21.
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftSpinner
import CoreLocation

class ExploreController : UIViewController{

    fileprivate let data = [
        Places(venueName: "China Town", rating: 1.5, venueImage: #imageLiteral(resourceName: "onboard3"), distance: 2.0),
        Places(venueName: "China Town", rating: 1.5, venueImage: #imageLiteral(resourceName: "Burgers"), distance: 2.0),
        Places(venueName: "China Town", rating: 1.5, venueImage: #imageLiteral(resourceName: "Burgers"), distance: 2.0)
        
    ]
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization();
        $0.desiredAccuracy = kCLLocationAccuracyBest;
        $0.startUpdatingLocation();
        $0.startUpdatingHeading();
        return $0
        
    }(CLLocationManager())
    
    
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var nearbyView: UICollectionView!
    @IBOutlet weak var rngFoodTextField: UITextField!

    
    override func viewDidLoad() {

        registerNib()
        
        profileBtn.layer.cornerRadius = 45
        profileBtn.layer.shadowColor = UIColor.lightGray.cgColor
        profileBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        profileBtn.layer.shadowRadius = 5
        profileBtn.layer.shadowOpacity = 1.0
        
        let imageView = UIImageView();
        let image = UIImage(systemName: "search")
        imageView.image = image;
        
        rngFoodTextField.leftViewMode = UITextField.ViewMode.always
        
        rngFoodTextField.leftView = imageView;
        
        let (lat, long) = getCurrentLocation();
        
        requestPlacesNearby(lat: lat, long: long, radius: "500", keyword: "", type: "restaurant")
        
    }
    
    func getCurrentLocation()->(String, String){
        let currentLocation = locationManager.location;
        let lat = String((currentLocation?.coordinate.latitude)!)
        let long = String((currentLocation?.coordinate.longitude)!)
        
        return (lat, long)
    }
    
    func requestPlacesNearby(lat:String, long:String, radius:String, keyword:String, type:String){
        
        //Api key
        let apiKey = "AIzaSyDt0QPH_9Bl0h9xWLw2PIFLpnOrcDxGYII"
        
        let place : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/"
        
        //lat and long
        var url:String = place + "json?location=" + lat + "," + long;
        
        //radius
        url = url + "&radius="+radius;
        
        //type
        url = url + "&type="+type;
        
        //keyword
        url = url + "&keyword=" + keyword;
        
        //key
        url = url + "&key=" + apiKey;
        
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                
                let place = try decoder.decode(PlaceModel.self, from: data!)

                print(place.results!.count)
            } catch {
                print("error, unable to request data")
            }
        })
        
        task.resume()

    }
    
    func registerNib() {
        print("Registering Nib")
        let nib = UINib(nibName: nearbyCellCollectionViewCell.nibName, bundle: nil)
        nearbyView.register(nib, forCellWithReuseIdentifier: nearbyCellCollectionViewCell.reuseIdentifier)
        
        if let flowLayout = nearbyView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: view.frame.width, height: 230)


            print("Registering item size")
            
        }
    }
    
}


extension ExploreController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(data.count)

        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nearbyCellCollectionViewCell.reuseIdentifier, for: indexPath) as? nearbyCellCollectionViewCell {
            let venue = data[indexPath.row]
            print("Loading data to cell")
            
            cell.configureCell(place: venue)
            print("Loaded data to cell")
            
            // cell.configureCell()
            return cell
        }
        print("Return UICollectionViewCell")

        return UICollectionViewCell()
    }
}


extension ExploreController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: nearbyCellCollectionViewCell = Bundle.main.loadNibNamed(nearbyCellCollectionViewCell.nibName, owner: self, options: nil)?.first as? nearbyCellCollectionViewCell else {
            return CGSize(width: view.frame.width, height: 230)
        }
        print("Configuring cell")
        print(data[indexPath.row])
        cell.configureCell(place: data[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return CGSize(width: view.frame.width, height: 230)
    }
}
