import Foundation
struct Result : Codable {
	let opening_hours : Opening_hours?

	enum CodingKeys: String, CodingKey {

		case opening_hours = "opening_hours"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		opening_hours = try values.decodeIfPresent(Opening_hours.self, forKey: .opening_hours)
	}

}
