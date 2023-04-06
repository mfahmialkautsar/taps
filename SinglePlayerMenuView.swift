import SwiftUI

struct SinglePlayerMenuView: View {
  @Environment(\.dismiss) var dismiss
  @State var v: SinglePlayerGameView?
  @State var difficulty: Difficulty? {
    didSet {
      guard let difficulty = difficulty else {
        return
      }
      let player = Player()
      player.shapes = [.triangle]
      let gamePresenter = GamePresenter(players: [player], diffifulty: difficulty)
      v = SinglePlayerGameView(game: gamePresenter)
    }
  }

  var body: some View {
    if difficulty == nil {
      VStack {
        GeometryReader { _ in
          BackButton(dismiss: dismiss)
          VStack {
            Spacer()
            ForEach(0 ..< Difficulty.allCases.count, id: \.self) { i in
              Button {
                difficulty = Difficulty.allCases[i]
              } label: {
                VStack {
                  Text("\(Difficulty.allCases[i])".capitalized)
                }
                .padding(32)
                .frame(maxWidth: 500)
                .font(.title)
              }
              .btnStyle()
            }
            Spacer()
            Text("Hint: Tap the triangles to get points and avoid the other shape")
              .font(.title)
              .padding(.bottom)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .background(Color.main)
      .navigationBarHidden(true)
    } else if let v = v {
      v
    }
  }
}
