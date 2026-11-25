import Foundation

struct ZeldaResponse: Decodable {
    let success: Bool
    let count: Int
    let data: [ZeldaGame]

    struct ZeldaGame: Decodable, Identifiable {
        let id: String
        let name: String
        let description: String
        let developer: String
        let publisher: String
        let released_date: String
    }
}
