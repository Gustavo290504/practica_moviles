import SwiftUI

struct MonsterDetailView: View {
    @AppStorage("userName") var userName = ""
    let monster: MonsterResponse.Monster

    var locations: [String] {
        monster.common_locations ?? []
    }

    var droppedItems: [String] {
        monster.drops ?? []
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text(monster.name.uppercased())
                        .font(.title)
                        .fontWeight(.bold)

                    AsyncImage(url: URL(string: monster.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 250, height: 250)

                    Text("\(userName), Hey Listen")

                    Text(monster.description)
                        .multilineTextAlignment(.center)

                    if !locations.isEmpty {
                        Text("COMMON LOCATIONS")
                            .fontWeight(.bold)
                        ForEach(locations, id: \.self) { location in
                            Text(location)
                        }
                    }

                    if !droppedItems.isEmpty {
                        Text("DROPPABLE ITEMS")
                            .fontWeight(.bold)
                        ForEach(droppedItems, id: \.self) { item in
                            Text(item)
                        }
                    }
                }
                .foregroundStyle(.yellow)
                .padding()
            }
        }
    }
}
