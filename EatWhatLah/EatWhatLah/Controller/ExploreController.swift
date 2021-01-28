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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var dataNearByVenue = [Places]()
    
    var resultVenues = [Results]();
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization();
        $0.desiredAccuracy = kCLLocationAccuracyBest;
        $0.startUpdatingLocation();
        $0.startUpdatingHeading();
        return $0
        
    }(CLLocationManager())
    
    let categoriesList:[(String, UIImage?)] = [("Cafe", UIImage(named:"cafe")),("Hawker", UIImage(named:"hawker")),("Bakery", UIImage(named:"bakery")),("Bar", UIImage(named:"bar")),("Buffet", UIImage(named:"buffet"))]
    
    
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var nearbyView: UICollectionView!
    @IBOutlet var categoryView: UICollectionView!
    
    @IBOutlet weak var rngFoodTextField: UITextField!
    
    
    override func viewDidLoad() {
        self.registerNib();
        
        let (lat, long) = getCurrentLocation();
        nearbyView.delegate = self;
        nearbyView.dataSource = self;
        nearbyView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        
        requestPlacesNearby(lat: lat, long: long, radius: "500", keyword: "", type: "restaurant")
        
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
        
        //Get Request for nearby restaurant
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                
                let responseDecode = try decoder.decode(PlaceModel.self, from: data!)
                
                let placesResponse = responseDecode.results
                
                self.resultVenues = responseDecode.results!
                
                for i in 0...placesResponse!.count-1{
                    let distance:Double = (placesResponse?[i].geometry?.location!.distance)!;
                    
                    let name:String = (placesResponse?[i].name)!
                    var rating:String = "0"
                    
                    if(placesResponse?[i].rating != nil){
                        rating = String(format: "%.1f", Double(((placesResponse?[i].rating)!)))
                    }
                    
                    var venueImageURL:String = "";
                    let placeID:String = (placesResponse?[i].place_id)!
                    
                    if(placesResponse?[i].photos?[0].photo_reference != nil){
                        venueImageURL =  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + (placesResponse?[i].photos?[0].photo_reference)! + "&sensor=true&key=AIzaSyDt0QPH_9Bl0h9xWLw2PIFLpnOrcDxGYII"
                    }
                    
                    
                    let place = Places(venueName: name, rating: rating, venueImage: venueImageURL, distance: distance, place_id: placeID)
                    
                    self.dataNearByVenue.append(place)
                    
                    //An object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.
                    DispatchQueue.main.async {
                        self.nearbyView.reloadData()
                    }
                    
                }
                
                print("Completed")
            } catch {
                print("error, unable to request data")
            }
        })
        
        task.resume()
        print("Reloaded Data")
        
    }
    
    
    @IBAction func viewMoreNearbyOnClick(_ sender: Any) {
        appDelegate.ListOfPlaces = resultVenues;
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "viewMoreSB")
        
        nextViewController.modalPresentationStyle = .fullScreen
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    //Register Nib of UI collecitonView
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
        
        if collectionView == self.nearbyView {
            
            print(dataNearByVenue.count)
            return dataNearByVenue.count
            
        }else if collectionView == self.categoryView{
            return categoriesList.count
        }
        
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.nearbyView {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nearbyCellCollectionViewCell.reuseIdentifier, for: indexPath) as? nearbyCellCollectionViewCell {
                let venue = dataNearByVenue[indexPath.row]
                print("Loading data to cell")
                
                cell.configureCell(place: venue)
                print("Loaded data to cell")
                
                // cell.configureCell()
                return cell
            }
            print("Return UICollectionViewCell")
            
        }else if collectionView == self.categoryView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellcollectionViewCell.reuseIdentifier, for: indexPath) as? categoryCellcollectionViewCell {
                
                let (name, image) = categoriesList[indexPath.row]
                
                cell.configureCell(name: name, image: image!)
                return cell
            }
            print("Return UICollectionViewCell")
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.nearbyView {
            
            let cell = collectionView.cellForItem(at: indexPath) as? nearbyCellCollectionViewCell
            
            appDelegate.selectedPlaceImage = cell?.venueImageView.image
            appDelegate.selectedPlace = resultVenues[indexPath.row]
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "venueDetailview")
            
            nextViewController.modalPresentationStyle = .fullScreen
            
            self.present(nextViewController, animated:true, completion:nil)
        }else if collectionView == self.categoryView{
        }else{
            
        }
    }
}


extension ExploreController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.nearbyView {
            
            guard let cell: nearbyCellCollectionViewCell = Bundle.main.loadNibNamed(nearbyCellCollectionViewCell.nibName, owner: self, options: nil)?.first as? nearbyCellCollectionViewCell else {
                return CGSize(width: view.frame.width, height: 240)
            }
            print("Configuring cell")
            print(dataNearByVenue[indexPath.row])
            cell.configureCell(place: dataNearByVenue[indexPath.row])
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return CGSize(width: view.frame.width, height: 240)
        }else{
            guard let cell: categoryCellcollectionViewCell = Bundle.main.loadNibNamed("categoryCellcollectionViewCell", owner: self, options: nil)?.first as? categoryCellcollectionViewCell else {
                return CGSize(width: view.frame.width, height: 240)
            }
            
            
            let (name, image) = categoriesList[indexPath.row]
            
            cell.configureCell(name: name, image: image!)

            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return CGSize(width: view.frame.width, height: 240)
        }
    }
}
