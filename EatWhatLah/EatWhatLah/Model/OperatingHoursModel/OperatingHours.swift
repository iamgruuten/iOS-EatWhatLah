import Foundation
struct OperatingHours : Codable {
	let html_attributions : [String]?
	let result : Result?
	let status : String?

	enum CodingKeys: String, CodingKey {

		case html_attributions = "html_attributions"
		case result = "result"
		case status = "status"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		html_attributions = try values.decodeIfPresent([String].self, forKey: .html_attributions)
		result = try values.decodeIfPresent(Result.self, forKey: .result)
		status = try values.decodeIfPresent(String.self, forKey: .status)
	}

}
