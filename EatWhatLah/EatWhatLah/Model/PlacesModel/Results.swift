import Foundation
struct Results : Codable {
	var business_status : String?
	var geometry : Geometry?
	var icon : String?
	var name : String?
	var permanently_closed : Bool?
	var photos : [Photos]?
	var place_id : String?
	var plus_code : Plus_code?
	var price_level : Int?
	var rating : Double?
	var reference : String?
	var scope : String?
	var types : [String]?
	var user_ratings_total : Int?
	var vicinity : String?

	enum CodingKeys: String, CodingKey {

		case business_status = "business_status"
		case geometry = "geometry"
		case icon = "icon"
		case name = "name"
		case permanently_closed = "permanently_closed"
		case photos = "photos"
		case place_id = "place_id"
		case plus_code = "plus_code"
		case price_level = "price_level"
		case rating = "rating"
		case reference = "reference"
		case scope = "scope"
		case types  = "types"
		case user_ratings_total = "user_ratings_total"
		case vicinity = "vicinity"
	}

	init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
		business_status = try values.decodeIfPresent(String.self, forKey: .business_status)
		geometry = try values.decodeIfPresent(Geometry.self, forKey: .geometry)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		permanently_closed = try values.decodeIfPresent(Bool.self, forKey: .permanently_closed)
		photos = try values.decodeIfPresent([Photos].self, forKey: .photos)
		place_id = try values.decodeIfPresent(String.self, forKey: .place_id)
		plus_code = try values.decodeIfPresent(Plus_code.self, forKey: .plus_code)
		price_level = try values.decodeIfPresent(Int.self, forKey: .price_level)
		rating = try values.decodeIfPresent(Double.self, forKey: .rating)
		reference = try values.decodeIfPresent(String.self, forKey: .reference)
		scope = try values.decodeIfPresent(String.self, forKey: .scope)
		types = try values.decodeIfPresent([String].self, forKey: .types)
		user_ratings_total = try values.decodeIfPresent(Int.self, forKey: .user_ratings_total)
		vicinity = try values.decodeIfPresent(String.self, forKey: .vicinity)
	}

}
