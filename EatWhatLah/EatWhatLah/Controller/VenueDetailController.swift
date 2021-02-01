//
//  VenueDetailController.swift
//  EatWhatLah
//
//  Created by Apple on 25/1/21.
//

import UIKit
import CoreLocation
import MapKit

protocol updateFavouriteDelegate {
    func didSendMessage(_ cookie: String)
}

class VenueDetailController:ViewController, MKMapViewDelegate{
    
    var appDelegate:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    var updateFavDelegate :updateFavouriteDelegate!

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var venueStatus: UILabel!
    
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet var operatingHoursLabel: UILabel!
    @IBOutlet var businessStatusLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var favouriteLabel: UIButton!
    
    let firebaseController:FirebaseController = FirebaseController();
    let favouriteController:FavouriteController = FavouriteController();
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    let regionRadius:CLLocationDistance = 250
    
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    let locationDelegate = LocationDelegate()
    var latestLocation: CLLocation? = nil
    
    var added:Int = 0;
    //1 - Added
    //0 - Not Added
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization();
        $0.desiredAccuracy = kCLLocationAccuracyBest;
        $0.startUpdatingLocation();
        $0.startUpdatingHeading();
        return $0
        
    }(CLLocationManager())
    
    
    @IBAction func backOnClick(_ sender: Any) {
        updateFavDelegate?.didSendMessage("Updated");

        self.dismiss(animated: true, completion: nil)
    }
    
    //Redirects user to map to navigate to the area
    @IBAction func exploreOnClick(_ sender: Any) {
        
        //Open in map for directions
        
        let lat1 : NSString = String((appDelegate.selectedPlace?.geometry?.location?.lat)!) as NSString
        let lng1 : NSString = String((appDelegate.selectedPlace?.geometry?.location?.lng)!) as NSString
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(appDelegate.selectedPlace?.name ?? "Pinned Location")"
        mapItem.openInMaps(launchOptions: options)
        
        
    }
    
    @IBAction func favouriteButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        let place = appDelegate.selectedPlace;
        
        getOperatingHours(placeID: (appDelegate.selectedPlace?.place_id)!)
        
        //reflect based on venue in coredata
        let buttonType:String;
        
        if(appDelegate.user.favourite.contains(where: {$0.place_id == place?.place_id})) {
            
            favouriteImage.image = UIImage(systemName: "heart.fill")
            buttonType = "Remove From Favourite"
            added = 1
        }else{
            favouriteImage.image = UIImage(systemName: "heart")
            buttonType = "Add To Favourite"

            added = 0
        }
        let myNormalAttributedTitle = NSAttributedString(string: buttonType,
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        favouriteLabel.setAttributedTitle(myNormalAttributedTitle, for: .normal)

        imageBackground.image = appDelegate.selectedPlaceImage;
        
        venueName.text = place?.name!.trimmingCharacters(in: .whitespacesAndNewlines);
        reviewLabel.text = String(place?.user_ratings_total ?? 0)
        ratingLabel.text = String(place?.rating ?? 0)
        venueStatus.text = place?.business_status;
        
        address.text = place?.vicinity;
        
        //Get Distance of two points
        let distance:Double = getDistance(lat: String((place?.geometry?.location?.lat)!), long: String((place?.geometry?.location?.lng)!))
        
        distanceLabel.text = String(format: "%.2f",distance) + "m away from you"
        
        detailView.layer.shadowColor = UIColor.lightGray.cgColor
        detailView.layer.shadowOffset = CGSize(width: 1, height: 1)
        detailView.layer.shadowRadius = 5
        detailView.layer.shadowOpacity = 1.0
        
        var annotations = [MKAnnotation]()
        
        let annotation = MKPointAnnotation()
        
        let lat:CLLocationDegrees = (place?.geometry?.location?.lat)!
        let lng:CLLocationDegrees = (place?.geometry?.location?.lng)!
        
        let venueCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        annotation.coordinate = venueCoordinate
        annotation.title = place?.name
        annotations.append(annotation)
        
        mapView.addAnnotations(annotations)
        
        // Boundanries
        let span = MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
        
        
        //Zoom in to location
        let region = MKCoordinateRegion(center: venueCoordinate, span: span)
        mapView.setRegion(region, animated: false)
        
        print("Added annonation and setting region")
        
    }
    
    func centerMapOnLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius
        )
        
        mapView.setRegion(coordinateRegion, animated: true);
    }
    
    func getOperatingHours(placeID:String)->Void{
        
        
        var request = URLRequest(url: URL(string: ("https://maps.googleapis.com/maps/api/place/details/json?place_id="
                                                    + placeID +
                                                    "&fields=name,opening_hours&key=AIzaSyDt0QPH_9Bl0h9xWLw2PIFLpnOrcDxGYII"))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                
                let responseDecode = try decoder.decode(OperatingHours.self, from: data!)
                
                let day = self.getDayOfWeek(Date())
                
                let operatingNow = responseDecode.result?.opening_hours?.open_now
                
                //Check if there are 7 if no then means its 24hrs
                var ClosingTime = "";
                var OpeningTime = "";
                
                if(responseDecode.result?.opening_hours?.periods?.count == 7){
                    ClosingTime = (responseDecode.result?.opening_hours?.periods![day! - 1].close?.time)!
                    
                    
                    OpeningTime = (responseDecode.result?.opening_hours?.periods![day!].open?.time)!
                }else{
                    ClosingTime = "24"
                }
                
                DispatchQueue.main.async {
                    
                    //First check if the area is open
                    
                    if(operatingNow != nil){
                        self.businessStatusLabel.isHidden = false;
                        self.operatingHoursLabel.isHidden = false;
                        if(operatingNow!){
                            
                            self.businessStatusLabel.text = "It is open now"
                            self.businessStatusLabel.textColor = UIColor.systemGreen
                            if(ClosingTime != "24"){
                                self.operatingHoursLabel.text = "Closing at " + ClosingTime;
                            }else{
                                self.operatingHoursLabel.text = "Operating at 24 Hours";
                                
                            }
                        }else{
                            //If no, display closed now (operating hours)
                            self.businessStatusLabel.text = "Closed, Come back tomorrow"
                            self.operatingHoursLabel.text = "Hours " + OpeningTime + " - " + ClosingTime;
                        }
                    }else{
                        self.businessStatusLabel.isHidden = true;
                        self.operatingHoursLabel.isHidden = true;
                    }
                }
                
                //If yes, display closing time
            }catch{
                print(error)
            }
        })
        
        task.resume()
        
    }
    
    @IBAction func addOnClick(_ sender: Any) {
        //Add to firebase
        let place:Places = Places();
        place.venueName = (appDelegate.selectedPlace?.name)!;
        place.lat = String((appDelegate.selectedPlace?.geometry?.location?.lat)!)
        place.long = String((appDelegate.selectedPlace?.geometry?.location?.lng)!)
        place.place_id = (appDelegate.selectedPlace?.place_id)!;
        place.venueImageData = appDelegate.selectedPlaceImage!;
        if(appDelegate.selectedPlace?.photos != nil){
            place.venueImage = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + (appDelegate.selectedPlace?.photos?[0].photo_reference)! + "&sensor=true&key=AIzaSyDt0QPH_9Bl0h9xWLw2PIFLpnOrcDxGYII"
        }else{
            place.venueImage = "0"
        }
        
        place.venueAddress = (appDelegate.selectedPlace?.vicinity!)!;
        
        //0 - means dont have
        
        //1 - means have
        
        let buttonType:String;
        
        if (added == 0) {
            added = 1
            favouriteController.addFavouriteToUser(user: appDelegate.user, place: place)
            
            firebaseController.addFavourite(uid: appDelegate.user.uid, place: place)
            
            favouriteLabel.setTitle("Remove From Favourites", for: .normal)
            buttonType = "Remove From Favourite"

            favouriteImage.image = UIImage(systemName: "heart.fill")
            
            
        }else{
            added = 0
            
            firebaseController.removeFavourite(uid: appDelegate.user.uid, place_id: place.place_id)
            
            favouriteController.removeFavouriteFromUser(user: appDelegate.user, place: place)
            buttonType = "Add To Favourite"
            favouriteImage.image = UIImage(systemName: "heart")
            
            

        }
        
        
        let myNormalAttributedTitle = NSAttributedString(string: buttonType,
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        favouriteLabel.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        updateFavDelegate?.didSendMessage("Updated");

        
    }
    
    //This function is used to get the date of the week
    func getDayOfWeek(_ todayDate:Date) -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    
}
