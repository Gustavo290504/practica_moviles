//
//  ZeldaModel.swift
//  ZeldaGames
//
//  Modelos que describen la respuesta JSON de:
//  https://zelda.fanapis.com/api/games
//
//  Forma del JSON:
//  {
//    "success": true,
//    "count": 2,
//    "data": [ { id, name, description, developer, publisher, released_date } ]
//  }
//

import Foundation

struct ZeldaResponse: Decodable {
    let success: Bool
    let count: Int
    let data: [ZeldaGame]

    // Un juego. Va dentro de ZeldaResponse, igual que Results dentro de Pokemon en el apunte 11.
    struct ZeldaGame: Decodable, Identifiable {
        let id: String
        let name: String
        let description: String
        let developer: String
        let publisher: String
        let released_date: String
    }
}
