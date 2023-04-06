import SwiftUI

struct MultiPlayerMenuView: View {
  @Environment(\.dismiss) var dismiss
  @State var multiplayerGameView: MultiplayerGameView?
  @State var splitDuoGameView: SplitDuoGameView?
  @State var numOfPlayers: PlayerNumEnum? {
    didSet {
      guard let numOfPlayers = numOfPlayers else {
        return
      }

      var players = [Player]()
      for playerNum in 0 ..< numOfPlayers.rawValue {
        let player = Player()
        var shapeEnum: ShapeEnum
        switch playerNum {
        case 0:
          shapeEnum = .triangle
        case 1:
          shapeEnum = .circle
        case 2:
          shapeEnum = .square
        case 3:
          shapeEnum = .pentagon
        default:
          shapeEnum = .triangle
        }
        player.shapes = [shapeEnum]
        players.append(player)
      }
      let gamePresenter = GamePresenter(players: players)
      multiplayerGameView = MultiplayerGameView(game: gamePresenter)
    }
  }

  func getDesc(playerNumEnum: PlayerNumEnum) -> String {
    switch playerNumEnum {
    case .one:
      return """
      Player 1: Triangle
      """
    case .two:
      return """
      Player 1: Triangle
      Player 2: Circle
      """
    case .three:
      return """
      Player 1: Triangle
      Player 2: Circle
      Player 3: Square
      """
    case .four:
      return """
      Player 1: Triangle
      Player 2: Circle
      Player 3: Square
      Player 4: Pentagon
      """
    }
  }

  var body: some View {
    if numOfPlayers == nil && splitDuoGameView == nil {
      VStack {
        GeometryReader { _ in
          BackButton(dismiss: dismiss)
          VStack {
            Button {
              let player1 = Player()
              player1.addShape(shape: .triangle)
              let player2 = Player()
              player2.addShape(shape: .triangle)
              let gamePresenter = GamePresenter(players: [player1, player2])
              splitDuoGameView = SplitDuoGameView(game: gamePresenter)
            } label: {
              VStack {
                Text("Split Duo")
                  .font(.title.bold())
                  .padding(.bottom, 4)
                Text("Split screen. Both player should tap the Triangles.")
                  .multilineTextAlignment(.leading)
              }
              .padding(32)
              .frame(maxWidth: 500)
              .font(.title)
            }
            .btnStyle()
            ForEach(1 ..< PlayerNumEnum.allCases.count, id: \.self) { i in
              Button {
                numOfPlayers = PlayerNumEnum.allCases[i]
              } label: {
                VStack {
                  Text("\(i + 1) Players")
                    .font(.title.bold())
                    .padding(.bottom, 4)
                  Text(getDesc(playerNumEnum: PlayerNumEnum.allCases[i]))
                    .multilineTextAlignment(.leading)
                }
                .padding(32)
                .frame(maxWidth: 500)
                .font(.title)
              }
              .btnStyle()
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarHidden(true)
        .background(Color.main)
      }
    } else if let multiplayerGameView = multiplayerGameView {
      multiplayerGameView
    } else if let splitDuoGameView = splitDuoGameView {
      splitDuoGameView
    }
  }
}
