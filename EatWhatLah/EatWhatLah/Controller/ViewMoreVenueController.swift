//
//  ViewMoreVenueController.swift
//  EatWhatLah
//
//  Created by Apple on 27/1/21.
//

import UIKit
import CoreLocation
import iOSDropDown

class ViewMoreVenueController:ViewController, UITableViewDelegate{
    
    @IBOutlet var noItemsView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var listOfPlaces:[Results] = [];
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization();
        $0.desiredAccuracy = kCLLocationAccuracyBest;
        $0.startUpdatingLocation();
        $0.startUpdatingHeading();
        return $0
        
    }(CLLocationManager())
    
    @IBOutlet var underScoreHalalLabel: UILabel!
    @IBOutlet var underScorePopularLabel: UILabel!
    @IBOutlet var underScoreVegeterainLabel: UILabel!
    
    @IBOutlet var popularButton: UIButton!
    @IBOutlet var VegeButton: UIButton!
    @IBOutlet var HalalButton: UIButton!
    
    @IBOutlet var sortDropDown: DropDown!
    @IBOutlet var dropDown: DropDown!
    @IBOutlet var VenuesTableView: UITableView!
    var radius:String = "500";
    var selectedPreference = "All";
    var favouriteController:FavouriteController = FavouriteController();
    var selectedCategory = "";
    
    override func viewDidLoad() {
        
        //selected category
        selectedCategory = appDelegate.selectedCategory.lowercased();
        
        //This is a dropdown array for distance
        dropDown.optionArray = ["500m", "1km", "1.5km", "2km", "2.5km", "3km", "5km"]
        dropDown.optionIds = [500,1000,1500,2000,2500,3000,5000]
        dropDown.cornerRadius = 10;
        dropDown.selectedIndex = 0;
        dropDown.text = "500m";
        
        dropDown.didSelect{(selectedText , index ,id) in
            self.radius = String(id);
            print("Radius Selected: " + String(id))
            
            if(self.selectedPreference == "Halal"){
                self.HalalOnClick((Any).self);
            }else if(self.selectedPreference == "All"){
                self.popularOnClick((Any).self);
                
            }else{
                self.VegeterainOnClick((Any).self);
            }
        }
        
        //This is a dropdown array for sorting
        
        sortDropDown.optionArray = ["Distance", "Price", "Popularity", "Rating"]
        sortDropDown.selectedIndex = 0;
        sortDropDown.cornerRadius = 10;
        sortDropDown.text = "Distance"
        
        sortDropDown.didSelect{(selectedText , index ,id) in
            self.sortedList(sortedString: selectedText)
        }
        
        
        //Loading list of places from delegate to prevent overloading of request
        listOfPlaces = appDelegate.ListOfPlaces;
        
        //For phone gesture - Shake
        self.becomeFirstResponder()
        
        //Table View
        VenuesTableView.delegate = self;
        VenuesTableView.dataSource = self;
        
        //Init - setting back to default value
        setDefault()
        underScorePopularLabel.isHidden = false;
        
        popularButton.tintColor = UIColor(hex: "#E63946")
    }
    
    @IBAction func popularOnClick(_ sender: Any) {
        setDefault();
        popularButton.tintColor = UIColor(hex: "#E63946")
        underScorePopularLabel.isHidden = false;
        
        //Filter based on korean
        let (lat, lng) = getLatLng()
        selectedPreference = "All";
        
        print(selectedCategory)
        if(selectedCategory == ""){
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: "", type: "restaurant")
        }
        else if(selectedCategory != "hawker" && selectedCategory != "buffet"){
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: "", type: selectedCategory)
        }else{
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: selectedCategory, type: "restaurant")
        }
    }
    
    @IBAction func VegeterainOnClick(_ sender: Any) {
        setDefault();
        VegeButton.tintColor = UIColor(hex: "#E63946")
        underScoreVegeterainLabel.isHidden = false;
        
        //Filter based on vegeterain
        
        let (lat, lng) = getLatLng()
        selectedPreference = "Vegan";
        
        if(selectedCategory == ""){
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: "vegan", type: "restaurant")
        }
        else if(selectedCategory != "hawker" && selectedCategory != "buffet"){
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: "vegan", type: selectedCategory)
        }else{
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: selectedCategory + ",vegan", type: "restaurant")
        }
        
    }
    
    @IBAction func HalalOnClick(_ sender: Any) {
        setDefault();
        HalalButton.tintColor = UIColor(hex: "#E63946")
        underScoreHalalLabel.isHidden = false;
        selectedPreference = "Halal";
        
        let (lat, lng) = getLatLng()
        
        //Filter based on halal
        if(selectedCategory == ""){
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: "halal", type: "restaurant")
        }
        else if(selectedCategory != "hawker" && selectedCategory != "buffet"){
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: "halal", type: selectedCategory)
        }else{
            requestPlacesNearby(lat: lat, long: lng, radius: radius, keyword: selectedCategory + ",halal", type: "restaurant")
        }
        
    }
    
    @IBAction func backOnClikck(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Hide all underscore
    
    func setDefault(){
        underScoreHalalLabel.isHidden = true;
        underScoreVegeterainLabel.isHidden = true;
        underScorePopularLabel.isHidden = true;
        
        popularButton.tintColor = UIColor(hex: "#1D3557")
        VegeButton.tintColor = UIColor(hex: "#1D3557")
        HalalButton.tintColor = UIColor(hex: "#1D3557")
        
        
    }
    
    // First responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let randomFloat = Int.random(in: 0..<listOfPlaces.count)
            
            let indexPath = IndexPath(row: randomFloat, section: 0)
            
            tableView(VenuesTableView, didSelectRowAt: indexPath);
            print("You shook me, now im gonna randomize!!! RAWRRR -QS developer :D Hi mr keck")
            
        }
    }
    
    //Get lat, lng - This can be deployed to appDelegate where it can be used
    func getLatLng()->(String, String){
        let lat = String((locationManager.location?.coordinate.latitude)!)
        let lng = String((locationManager.location?.coordinate.longitude)!)
        
        return (lat, lng)
    }
    
    //API Rquest based on filter, duplicate found in main but will reformat in the future
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
                
                self.listOfPlaces = responseDecode.results!
                
                DispatchQueue.main.async {
                    self.VenuesTableView.reloadData()
                }
                
                
                print("Completed")
            } catch {
                print("error, unable to request data")
            }
        })
        
        task.resume()
        print("Reloaded Data")
        
    }
    
    //Sort based on selected
    func sortedList(sortedString:String){
        if(sortedString == "Distance"){
            //omg idk... let me think again tmr :D
            self.listOfPlaces.sort(by: {$0.geometry?.location?.distance ?? 1000 < $1.geometry?.location?.distance ?? 1000})
            
        }else if(sortedString == "Price"){
            self.listOfPlaces.sort(by: {$0.price_level ?? 10 < $1.price_level ?? 10})
            

        }else if(sortedString == "Popularity"){
            self.listOfPlaces.sort(by: {$0.user_ratings_total ?? 0 > $1.user_ratings_total ?? 0})

        }else if(sortedString == "Rating"){
            self.listOfPlaces.sort(by: {$0.rating ?? 0 > $1.rating ?? 0})

        }
        self.VenuesTableView.reloadData()
        
    }
}
    

extension ViewMoreVenueController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(listOfPlaces.count == 0){
            tableView.backgroundView = noItemsView;
        }else{
            tableView.backgroundView = nil;
        }
        
        return listOfPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! customCellVenue
        
        let place = listOfPlaces[indexPath.row]
        cell.venueName.text = place.name
        cell.addressLabel.text = place.vicinity
        cell.venueImageView.image = #imageLiteral(resourceName: "noResult")
        cell.ratingLabel.text = String(place.rating ?? 0)
        
        if(place.photos != nil){
            let url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + (place.photos?[0].photo_reference)! + "&sensor=true&key=AIzaSyDt0QPH_9Bl0h9xWLw2PIFLpnOrcDxGYII"
            
            cell.venueImageView?.downloaded(from: url)
        }
        
        var price = ""
        if(place.price_level != nil){
            for _ in 0...place.price_level! {
                price = price + "$"
            }
            cell.priceLabel.text = price
        }else{
            cell.priceLabel.text = "??"
        }
        
        var distance:Double = (place.geometry?.location!.distance)!;
        
        if(distance.isLess(than: 1000)){
        cell.distanceLabel.text =  String(format: "%.0f", distance) + " m"
        }else{
            distance = distance / 1000;
            cell.distanceLabel.text =  String(format: "%.0f", distance) + " km"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? customCellVenue
        
        appDelegate.selectedPlaceImage = cell?.venueImageView.image
        appDelegate.selectedPlace = listOfPlaces[indexPath.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "venueDetailview") as! VenueDetailController
        nextViewController.updateFavDelegate = self;

        nextViewController.modalPresentationStyle = .fullScreen
        
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
    
    
}

//Create a protocol to know if there is any changes to the database
extension ViewMoreVenueController : updateFavouriteDelegate{
    func didSendMessage(_ message:String) {
        print("Im reloading my data")

        favouriteController.retrieveFavouriteByUID(uid: appDelegate.user.uid){
            favouriteList in
            
            self.appDelegate.user.favourite = favouriteList
            
            print("Im reloading my data")
        }
    }
}


