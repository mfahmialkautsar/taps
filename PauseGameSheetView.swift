import SwiftUI

struct PauseGameSheetView: View {
  @Environment(\.dismiss) var dismiss
  let dismissParent: DismissAction
  let game: GamePresenter

  var body: some View {
    VStack {
      Text("Game Paused")
        .multilineTextAlignment(.center)
        .padding(.bottom)
        .font(.largeTitle)
      HStack {
        Button("Quit") {
          game.stop()
          dismiss()
          dismissParent()
        }
        .padding()
        .background(.red)
        .foregroundColor(.white)
        .cornerRadius(16)
        .padding(.trailing, 32)
        Button("Resume") {
          dismiss()
        }
        .padding()
        .foregroundColor(.mainBlack)
        .background(.white)
        .cornerRadius(16)
        .foregroundColor(.black)
        .shadow(color: .secondary.opacity(0.3), radius: 2, x: 0, y: 1)
      }
      .font(.title)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .background(Color.main)
  }
}
