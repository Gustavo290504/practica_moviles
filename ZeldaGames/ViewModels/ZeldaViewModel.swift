//
//  ZeldaViewModel.swift
//  ZeldaGames
//
//  Hace la peticion HTTP a la API de Zelda (apunte 11).
//

import Foundation
import Observation

@MainActor
@Observable
final class ZeldaViewModel {
    // Valor inicial = "aun no se ha consumido la API" (count -1)
    var response = ZeldaResponse(success: false, count: -1, data: [])

    // Cuantos juegos pedir. Cambia este numero para traer mas o menos.
    private let limit = 2

    func getGames() async {
        let endPoint = "https://zelda.fanapis.com/api/games?limit=\(limit)"
        guard let apiURL = URL(string: endPoint) else {
            print("Url no valida o no definida")
            return
        }

        var urlRequest = URLRequest(url: apiURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            // Ojo: la variable local se llama urlResponse para no chocar con la propiedad "response"
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("Error: sin respuesta del servidor")
                return
            }

            guard httpResponse.statusCode == 200 else {
                print("Status \(httpResponse.statusCode)")
                return
            }

            let decoded = try JSONDecoder().decode(ZeldaResponse.self, from: data)
            response = decoded
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
