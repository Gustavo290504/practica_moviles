//
//  FavoriteGame.swift
//  ZeldaGames
//
//  Modelo de SwiftData: lo que se guarda en el dispositivo cuando le das like a un juego.
//

import Foundation
import SwiftData

@Model
final class FavoriteGame {
    // "gameID" y no "id": es el id que viene de la API (texto), y asi no se confunde
    // con la identidad que SwiftData ya le da a cada objeto guardado.
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
