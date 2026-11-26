import Foundation
import Observation

@MainActor
@Observable
final class MonsterViewModel {
    var response = MonsterResponse(data: [])

    func getMonsters() async {
        let endPoint = "https://api.hyrule-compendium.com/v3/compendium/category/monsters"
        guard let apiURL = URL(string: endPoint) else {
            print("Url no valida o no definida")
            return
        }

        var urlRequest = URLRequest(url: apiURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("Error: sin respuesta del servidor")
                return
            }

            guard httpResponse.statusCode == 200 else {
                print("Status \(httpResponse.statusCode)")
                return
            }

            let decoded = try JSONDecoder().decode(MonsterResponse.self, from: data)
            response = decoded
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
