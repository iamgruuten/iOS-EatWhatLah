import Foundation
struct Opening_hours : Codable {
	let open_now : Bool?
	let periods : [Periods]?
	let weekday_text : [String]?

	enum CodingKeys: String, CodingKey {

		case open_now = "open_now"
		case periods = "periods"
		case weekday_text = "weekday_text"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		open_now = try values.decodeIfPresent(Bool.self, forKey: .open_now)
		periods = try values.decodeIfPresent([Periods].self, forKey: .periods)
		weekday_text = try values.decodeIfPresent([String].self, forKey: .weekday_text)
	}

}
