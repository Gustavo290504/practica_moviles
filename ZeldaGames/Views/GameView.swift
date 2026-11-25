//
//  GameView.swift
//  ZeldaGames
//
//  Pestana 1: lista de juegos que vienen de la API.
//  Cada fila: NavigationLink al detalle + corazon para dar like.
//  En la barra de arriba: boton para dar like a todos.
//

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

                            // borderless: hace que el corazon reciba su propio toque
                            // y no dispare el NavigationLink de la fila.
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

    // ¿Este juego ya esta guardado? Se compara por id (unico).
    private func esFavorito(_ game: ZeldaResponse.ZeldaGame) -> Bool {
        return !favorites.filter { $0.gameID == game.id }.isEmpty
    }

    // Convierte un juego de la API en un objeto guardable.
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

    // Like a un juego; si ya era favorito, lo quita.
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

    // Like a todos los juegos de la lista (los que ya eran favoritos se saltan).
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
