import Foundation
struct Close : Codable {
	let day : Int?
	let time : String?

	enum CodingKeys: String, CodingKey {

		case day = "day"
		case time = "time"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		day = try values.decodeIfPresent(Int.self, forKey: .day)
		time = try values.decodeIfPresent(String.self, forKey: .time)
	}

}
