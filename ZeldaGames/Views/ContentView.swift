import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Juegos", systemImage: "gamecontroller") {
                GameView()
            }
            Tab("Favoritos", systemImage: "heart.fill") {
                FavoriteView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FavoriteGame.self, inMemory: true)
}
