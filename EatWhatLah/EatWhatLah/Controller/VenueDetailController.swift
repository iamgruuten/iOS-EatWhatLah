//
//  VenueDetailController.swift
//  EatWhatLah
//
//  Created by Apple on 25/1/21.
//

import UIKit
import CoreLocation
import MapKit

class VenueDetailController:ViewController, MKMapViewDelegate{
    
    var appDelegate:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var venueStatus: UILabel!
    
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var favouriteLabel: UIButton!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    let regionRadius:CLLocationDistance = 250
    
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    let locationDelegate = LocationDelegate()
    var latestLocation: CLLocation? = nil
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization();
        $0.desiredAccuracy = kCLLocationAccuracyBest;
        $0.startUpdatingLocation();
        $0.startUpdatingHeading();
        return $0
        
    }(CLLocationManager())

    @IBAction func backOnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    override func viewDidLoad() {
        
        let place = appDelegate.selectedPlace;

        if(appDelegate.user.favourite.contains(where: {$0.place_id == place?.place_id})) {
            favouriteImage.image = UIImage(systemName: "heart.fill")
            favouriteLabel.titleLabel?.text = "Added To Favourites"
        }else{
            favouriteImage.image = UIImage(systemName: "heart")
            favouriteLabel.titleLabel?.text = "Add To Favourites"

        }
        
        imageBackground.image = appDelegate.selectedPlaceImage;
        
        venueName.text = place?.name;
        reviewLabel.text = String((place?.user_ratings_total)!);
        
        venueStatus.text = place?.business_status;
        address.text = place?.vicinity;
        
        //Get Distance of two points
        let distance:Double = getDistance(lat: String((place?.geometry?.location?.lat)!), long: String((place?.geometry?.location?.lng)!))
        
        distanceLabel.text = String(distance) + "m away from you"
        
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
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        
        
        //Zoom in to location
        let region = MKCoordinateRegion(center: venueCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func centerMapOnLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius
        )
        
        mapView.setRegion(coordinateRegion, animated: true);
    }
    
    //Return distance from two pin location
    func getDistance(lat:String, long:String)->Double{
        
        let pinLocation = CLLocation(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(long)!)
        
        guard let currentLocation = locationManager.location else {
            return 0.0
        }
                
        let distance = pinLocation.distance(from: currentLocation)
        
        print(String(format: "The distance to location is %.01fm", distance))

        return Double(String(format: "%.0f", distance)) ?? 0.0;
    }
}
