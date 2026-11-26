import Foundation

struct MonsterResponse: Decodable {
    let data: [Monster]

    struct Monster: Decodable, Identifiable {
        let id: Int
        let name: String
        let image: String
        let description: String
        let common_locations: [String]?
        let drops: [String]?
    }
}
