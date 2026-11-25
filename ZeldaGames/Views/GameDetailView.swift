import SwiftUI
import SwiftData

struct GameDetailView: View {
    let gameID: String
    let name: String
    let gameDescription: String
    let developer: String
    let publisher: String
    let releasedDate: String

    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteGame]

    private var cleanDescription: String {
        let text = gameDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            return "Sin descripción"
        }
        return text
    }

    private var cleanDate: String {
        return releasedDate.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var esFavorito: Bool {
        return !favorites.filter { $0.gameID == gameID }.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)

                Text(name)
                    .font(.largeTitle)
                    .bold()

                Text("Desarrollador: \(developer)")
                Text("Publicado por: \(publisher)")
                Text("Lanzamiento: \(cleanDate)")

                Divider()

                Text(cleanDescription)
                    .font(.body)

                Button {
                    toggleFavorite()
                } label: {
                    if esFavorito {
                        Label("Quitar de favoritos", systemImage: "heart.fill")
                    } else {
                        Label("Agregar a favoritos", systemImage: "heart")
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .navigationTitle("Detalle")
    }

    private func toggleFavorite() {
        let matches = favorites.filter { $0.gameID == gameID }
        if matches.isEmpty {
            modelContext.insert(
                FavoriteGame(
                    gameID: gameID,
                    name: name,
                    gameDescription: gameDescription,
                    developer: developer,
                    publisher: publisher,
                    releasedDate: releasedDate
                )
            )
        } else {
            for fav in matches {
                modelContext.delete(fav)
            }
        }
        do {
            try modelContext.save()
        } catch {
            print("Error al guardar: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        GameDetailView(
            gameID: "preview",
            name: "The Legend of Zelda",
            gameDescription: "Texto de ejemplo para ver el diseño.",
            developer: "Nintendo R&D 4",
            publisher: "Nintendo",
            releasedDate: " February 21, 1986"
        )
    }
    .modelContainer(for: FavoriteGame.self, inMemory: true)
}
