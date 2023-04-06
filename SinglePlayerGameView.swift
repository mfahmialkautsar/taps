import SwiftUI

struct SinglePlayerGameView: View {
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
              .padding(.top)
              .font(.largeTitle)
            HStack {
              Text("Score: " + String(game.players[0].score))
              Spacer()
              PauseButton(game: game)
            }
            .padding()
          }
          .font(.title)
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
        FinishGameSheetView(dismissParent: dismiss, score: game.players[0].score)
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
        game.clickShape(uuid: game.circles[i].id, player: game.players[0], proxy: proxy, shape: .circle)
      }
    }
    .disabled(!game.isStarted)
    ForEach(0 ..< game.squares.count, id: \.self) { i in
      game.squares[i].onTapGesture {
        game.clickShape(uuid: game.squares[i].id, player: game.players[0], proxy: proxy, shape: .square)
      }
    }
    .disabled(!game.isStarted)
    ForEach(0 ..< game.pentagons.count, id: \.self) { i in
      game.pentagons[i].onTapGesture {
        game.clickShape(uuid: game.pentagons[i].id, player: game.players[0], proxy: proxy, shape: .pentagon)
      }
    }
    .disabled(!game.isStarted)
  }
}

fileprivate struct FinishGameSheetView: View {
  @Environment(\.dismiss) var dismiss
  let dismissParent: DismissAction
  var score: Int

  var body: some View {
    VStack {
      Text("Time's up!")
        .font(.largeTitle)
        .padding(.bottom)
      Text("Your score:")
        .padding(.bottom, 8)
        .font(.title)
      Text(String(score))
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
