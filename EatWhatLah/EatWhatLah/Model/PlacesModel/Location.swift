import Foundation
import CoreData

let locationManager: CLLocationManager = {
    $0.requestWhenInUseAuthorization();
    $0.desiredAccuracy = kCLLocationAccuracyBest;
    $0.startUpdatingLocation();
    $0.startUpdatingHeading();
    return $0
    
}(CLLocationManager())

struct Location : Codable {
	let lat : Double?
	let lng : Double?
    let distance : Double

	enum CodingKeys: String, CodingKey {

		case lat = "lat"
		case lng = "lng"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		lat = try values.decodeIfPresent(Double.self, forKey: .lat)
		lng = try values.decodeIfPresent(Double.self, forKey: .lng)
        
        distance = getDistance(lat: String(lat!), long: String(lng!))
	}

}


//Return distance from two pin location
func getDistance(lat:String, long:String)->Double{
    
    let pinLocation = CLLocation(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(long)!)
    
    guard let currentLocation = locationManager.location else {
        return 0.0
    }
    
    let distance = pinLocation.distance(from: currentLocation)
        
    return distance;
}
