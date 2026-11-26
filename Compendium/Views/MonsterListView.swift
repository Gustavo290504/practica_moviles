import SwiftUI

struct MonsterListView: View {
    @State private var vm = MonsterViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Text("Compendium")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(vm.response.data) { monster in
                                NavigationLink(destination: MonsterDetailView(monster: monster)) {
                                    HStack(spacing: 12) {
                                        AsyncImage(url: URL(string: monster.image)) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))

                                        VStack(alignment: .leading) {
                                            Text(monster.name.uppercased())
                                                .foregroundStyle(.yellow)
                                            Text("ID: \(monster.id)")
                                                .foregroundStyle(.blue)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .task {
                await vm.getMonsters()
            }
        }
    }
}

#Preview {
    MonsterListView()
}
