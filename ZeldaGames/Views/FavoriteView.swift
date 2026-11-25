//
//  FavoriteView.swift
//  ZeldaGames
//
//  Pestana 2: los juegos que guardaste (SwiftData).
//  Tocar uno abre su detalle; deslizar una fila lo borra.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    @Query private var favorites: [FavoriteGame]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(favorites) { fav in
                    NavigationLink(
                        destination: GameDetailView(
                            gameID: fav.gameID,
                            name: fav.name,
                            gameDescription: fav.gameDescription,
                            developer: fav.developer,
                            publisher: fav.publisher,
                            releasedDate: fav.releasedDate
                        ),
                        label: {
                            HStack {
                                Image(systemName: "gamecontroller.fill")
                                    .font(.title)
                                    .foregroundColor(.green)
                                    .frame(width: 50)

                                VStack(alignment: .leading) {
                                    Text(fav.name)
                                        .font(.headline)
                                    Text(fav.developer)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    )
                }
                .onDelete(perform: borrar)
            }
            .navigationTitle("Favoritos")
            .overlay {
                if favorites.isEmpty {
                    Text("Aún no tienes favoritos")
                        .foregroundColor(.gray)
                }
            }
        }
    }

    private func borrar(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favorites[index])
        }
        do {
            try modelContext.save()
        } catch {
            print("Error al borrar: \(error)")
        }
    }
}

#Preview {
    FavoriteView()
        .modelContainer(for: FavoriteGame.self, inMemory: true)
}
