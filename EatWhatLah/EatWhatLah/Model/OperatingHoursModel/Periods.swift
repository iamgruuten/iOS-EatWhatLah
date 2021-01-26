import Foundation
struct Periods : Codable {
	let close : Close?
	let open : Open?

	enum CodingKeys: String, CodingKey {

		case close = "close"
		case open = "open"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		close = try values.decodeIfPresent(Close.self, forKey: .close)
		open = try values.decodeIfPresent(Open.self, forKey: .open)
	}

}
