import SwiftUI

struct ContentView: View {
    @AppStorage("userName") var userName = ""
    @State private var nameInput = ""

    var body: some View {
        if userName.isEmpty {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Compendium")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                    TextField("Tu nombre", text: $nameInput)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Button("Entrar") {
                        userName = nameInput
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        } else {
            MonsterListView()
        }
    }
}

#Preview {
    ContentView()
}
