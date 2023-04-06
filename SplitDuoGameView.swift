import SwiftUI

struct SplitDuoGameView: View {
  @Environment(\.dismiss) var dismiss: DismissAction
  @ObservedObject var game: GamePresenter
  @State var proxies = [GeometryProxy]()

  func updateVal() {
    guard proxies.count > 1 else {
      return
    }
    game.start(proxies: proxies)
  }

  var body: some View {
    VStack {
      MainView(index: 1, game: game, proxies: $proxies.onUpdate {
        updateVal()
      })
        .rotationEffect(.degrees(180))
      Divider()
        .background(.black)
      MainView(index: 0, game: game, proxies: $proxies)
    }
    .sheet(isPresented: $game.isModalOpen) {
      PauseGameSheetView(dismissParent: dismiss, game: game)
    }
    .sheet(isPresented: $game.showTimesUpSheet) {
      FinishGameSheetView(dismissParent: dismiss, players: game.players)
    }
    .background(Color.main)
    .navigationBarHidden(true)
  }
}

fileprivate struct MainView: View {
  let index: Int
  @ObservedObject var game: GamePresenter
  @Binding var proxies: [GeometryProxy]

  var body: some View {
    GeometryReader { proxy in
      GeometryReader { _ in
        if proxies.count > 1 {
          if game.startCountDown >= 0 {
            VStack {
              if game.startCountDown == 0 {
                Text(String("Go!"))
              } else {
                Text("Ready")
                Text(String(game.startCountDown))
              }
            }
            .font(.system(size: 60))
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
          } else {
            if index == 0 {
              HStack {
                Spacer()
                PauseButton(game: game)
              }
            }
            VStack {
              Text(String(game.gameCountDown))
                .font(.largeTitle)
                .padding(.top)
              Text("Score: " + String(game.players[index].score))
                .font(.title)
                .padding()
            }
            ItemsView(index: index, game: game, proxy: proxy)
          }
        }
      }.onAppear {
        self.proxies.insert(proxy, at: index)
      }
      .disabled(game.isModalOpen)
    }
  }
}

fileprivate struct ItemsView: View {
  let index: Int
  var game: GamePresenter
  var proxy: GeometryProxy

  var body: some View {
    ForEach(0 ..< game.triangles.filter { $0.group == index }.count, id: \.self) { i in
      game.triangles.filter { $0.group == index }[i].onTapGesture {
        game.clickShape(uuid: game.triangles.filter { $0.group == index }[i].id, player: game.players[index], proxy: proxy, shape: .triangle, group: index)
      }
    }
    .disabled(!game.isStarted)
    ForEach(0 ..< game.circles.filter { $0.group == index }.count, id: \.self) { i in
      game.circles.filter { $0.group == index }[i].onTapGesture {
        game.clickShape(uuid: game.circles.filter { $0.group == index }[i].id, player: game.players[index], proxy: proxy, shape: .circle, group: index)
      }
    }
    .disabled(!game.isStarted)
    ForEach(0 ..< game.squares.filter { $0.group == index }.count, id: \.self) { i in
      game.squares.filter { $0.group == index }[i].onTapGesture {
        game.clickShape(uuid: game.squares.filter { $0.group == index }[i].id, player: game.players[index], proxy: proxy, shape: .square, group: index)
      }
    }
    .disabled(!game.isStarted)
    ForEach(0 ..< game.pentagons.filter { $0.group == index }.count, id: \.self) { i in
      game.pentagons.filter { $0.group == index }[i].onTapGesture {
        game.clickShape(uuid: game.pentagons.filter { $0.group == index }[i].id, player: game.players[index], proxy: proxy, shape: .pentagon, group: index)
      }
    }
    .disabled(!game.isStarted)
  }
}

fileprivate struct FinishGameSheetView: View {
  @Environment(\.dismiss) var dismiss
  let dismissParent: DismissAction
  var players: [Player]

  let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 2)

  var body: some View {
    VStack {
      Text("Time's up!")
        .font(.largeTitle)
        .padding(.bottom)
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(0 ..< players.count, id: \.self) { i in
          VStack {
            Text("Player \(i + 1) score:")
            Text(String(players[i].score))
          }
          .padding(.vertical)
        }
      }
      .padding(.bottom, 8)
      .font(.title)
      Button("Quit") {
        dismiss()
        dismissParent()
      }
      .font(.title)
      .buttonStyle(.bordered)
      .padding(.top)
    }
    .interactiveDismissDisabled()
  }
}
