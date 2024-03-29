//
//  AppDelegate.swift
//  EatWhatLah
//
//  Created by Apple on 20/1/21.
//

import UIKit
import CoreData
import CoreLocation
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var user:User = User();
    var password:String?
    var selectedPlace:Results?;
    var favouriteList:[Results]?;

    var ListOfPlaces:[Results] = [];
    
    var selectedCategory:String = "";

    var selectedPlaceImage:UIImage?;
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization();
        $0.desiredAccuracy = kCLLocationAccuracyBest;
        $0.startUpdatingLocation();
        $0.startUpdatingHeading();
        return $0
        
    }(CLLocationManager())
    
    //API Rquest based on filter, duplicate found in main but will reformat in the future
    func requestPlacesNearby(lat:String, long:String, radius:String, keyword:String, type:String, completion: @escaping (([Results]) -> Void)){
        
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
        var resultsVenues = [Results]();
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                
                let responseDecode = try decoder.decode(PlaceModel.self, from: data!)
                resultsVenues = responseDecode.results!
                print("Completed")
                
                completion(resultsVenues)

            } catch {
                print("error, unable to request data")
            }
        })
        
        task.resume()
        print("Reloaded Data")
        
    }
    
    //API Request based on placeID
    func getPlaceDetails(placeID:String, completionHandler:@escaping (_ postArray: Results)->Void){
        
        var request = URLRequest(url: URL(string: ("https://maps.googleapis.com/maps/api/place/details/json?place_id="
                                                    + placeID +
                                                    "&fields=business_status,geometry,icon,name,opening_hours,place_id,plus_code,rating,reference,scope,types,user_ratings_total,price_level,photo,vicinity&key=AIzaSyDt0QPH_9Bl0h9xWLw2PIFLpnOrcDxGYII"))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let decoder = JSONDecoder()
                
                let respDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]

                
                let dataResult = respDict["result"]
                
                let dataEdit = try JSONSerialization.data(withJSONObject: dataResult!, options:[])

                let responseDecode = try decoder.decode(Results.self, from: dataEdit)
                
                let placesResponse = responseDecode
                            
                completionHandler(placesResponse)
                
                print("Completed")
            } catch {
                print("error, unable to request data")
            }
        })
        
        task.resume()
        print("Reloaded Data")
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EatWhatLah")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Get Distance
    
    func getDistance(lat:String, long:String)->Double{
        
        let pinLocation = CLLocation(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(long)!)
        
        guard let currentLocation = locationManager.location else {
            return 0.0
        }
        
        let distance = pinLocation.distance(from: currentLocation)
            
        return distance;
    }
    
    override init(){
        
    }

}

