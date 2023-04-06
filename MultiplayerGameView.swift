import SwiftUI

struct MultiplayerGameView: View {
  @Environment(\.dismiss) var dismiss: DismissAction
  @ObservedObject var game: GamePresenter

  var body: some View {
    GeometryReader { proxy in
      GeometryReader { _ in
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
          VStack {
            Text(String(game.gameCountDown))
              .font(.largeTitle)
              .padding(.top)
            HStack {
              ForEach(0 ..< game.players.count, id: \.self) { i in
                Text("Player \(i + 1): " + String(game.players[i].score))
                  .padding(8)
              }
              Spacer()
              PauseButton(game: game)
            }
            .font(.title)
            .padding()
          }
          ItemsView(game: game, proxy: proxy)
        }
      }.onAppear {
        game.start(proxies: [proxy])
      }
      .disabled(game.isModalOpen)
      .sheet(isPresented: $game.isModalOpen) {
        PauseGameSheetView(dismissParent: dismiss, game: game)
      }
      .sheet(isPresented: $game.showTimesUpSheet) {
        FinishGameSheetView(dismissParent: dismiss, players: game.players)
      }
    }
    .background(Color.main)
    .navigationBarHidden(true)
  }
}

fileprivate struct ItemsView: View {
  var game: GamePresenter
  var proxy: GeometryProxy

  var body: some View {
    ForEach(0 ..< game.triangles.count, id: \.self) { i in
      game.triangles[i].onTapGesture {
        game.clickShape(uuid: game.triangles[i].id, player: game.players[0], proxy: proxy, shape: .triangle)
      }
    }
    .disabled(!game.isStarted)
    ForEach(0 ..< game.circles.count, id: \.self) { i in
      game.circles[i].onTapGesture {
        game.clickShape(uuid: game.circles[i].id, player: game.players[1], proxy: proxy, shape: .circle)
      }
    }
    .disabled(!game.isStarted)
    ForEach(0 ..< game.squares.count, id: \.self) { i in
      game.squares[i].onTapGesture {
        game.clickShape(uuid: game.squares[i].id, player: game.players[2], proxy: proxy, shape: .square)
      }
    }
    .disabled(!game.isStarted)
    ForEach(0 ..< game.pentagons.count, id: \.self) { i in
      game.pentagons[i].onTapGesture {
        game.clickShape(uuid: game.pentagons[i].id, player: game.players[3], proxy: proxy, shape: .pentagon)
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
            Text("Player \(i + 1):")
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
