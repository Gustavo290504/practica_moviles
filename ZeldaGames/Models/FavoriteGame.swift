import Foundation
import SwiftData

@Model
final class FavoriteGame {
    var gameID: String
    var name: String
    var gameDescription: String
    var developer: String
    var publisher: String
    var releasedDate: String

    init(gameID: String,
         name: String,
         gameDescription: String,
         developer: String,
         publisher: String,
         releasedDate: String) {
        self.gameID = gameID
        self.name = name
        self.gameDescription = gameDescription
        self.developer = developer
        self.publisher = publisher
        self.releasedDate = releasedDate
    }
}
