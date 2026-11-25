import SwiftUI
import SwiftData

struct GameView: View {
    @State private var vm = ZeldaViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteGame]

    var body: some View {
        NavigationStack {
            List(vm.response.data) { game in
                NavigationLink(
                    destination: GameDetailView(
                        gameID: game.id,
                        name: game.name,
                        gameDescription: game.description,
                        developer: game.developer,
                        publisher: game.publisher,
                        releasedDate: game.released_date
                    ),
                    label: {
                        HStack {
                            Image(systemName: "gamecontroller.fill")
                                .font(.title)
                                .foregroundColor(.green)
                                .frame(width: 50)

                            VStack(alignment: .leading) {
                                Text(game.name)
                                    .font(.headline)
                                Text(game.developer)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Button {
                                toggleFavorite(game)
                            } label: {
                                if esFavorito(game) {
                                    Image(systemName: "heart.fill")
                                } else {
                                    Image(systemName: "heart")
                                }
                            }
                            .foregroundColor(.red)
                            .buttonStyle(.borderless)
                        }
                    }
                )
            }
            .navigationTitle("Zelda Games")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        adoptAll()
                    } label: {
                        Label("Adoptar todos", systemImage: "heart.circle")
                    }
                }
            }
        }
        .task {
            await vm.getGames()
        }
    }

    private func esFavorito(_ game: ZeldaResponse.ZeldaGame) -> Bool {
        return !favorites.filter { $0.gameID == game.id }.isEmpty
    }

    private func makeFavorite(_ game: ZeldaResponse.ZeldaGame) -> FavoriteGame {
        return FavoriteGame(
            gameID: game.id,
            name: game.name,
            gameDescription: game.description,
            developer: game.developer,
            publisher: game.publisher,
            releasedDate: game.released_date
        )
    }

    private func toggleFavorite(_ game: ZeldaResponse.ZeldaGame) {
        let matches = favorites.filter { $0.gameID == game.id }
        if matches.isEmpty {
            modelContext.insert(makeFavorite(game))
        } else {
            for fav in matches {
                modelContext.delete(fav)
            }
        }
        guardarCambios()
    }

    private func adoptAll() {
        for game in vm.response.data {
            if esFavorito(game) { continue }
            modelContext.insert(makeFavorite(game))
        }
        guardarCambios()
    }

    private func guardarCambios() {
        do {
            try modelContext.save()
        } catch {
            print("Error al guardar: \(error)")
        }
    }
}

#Preview {
    GameView()
        .modelContainer(for: FavoriteGame.self, inMemory: true)
}
