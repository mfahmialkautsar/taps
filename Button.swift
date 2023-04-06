import Foundation
import SwiftUI

struct BackButton: View {
  let dismiss: DismissAction
  var body: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "chevron.left")
        .font(.system(size: 60))
    }
    .frame(width: 100, height: 100)
    .foregroundColor(.mainBlack)
    .background(Color.white)
    .cornerRadius(25)
    .shadow(color: .secondary.opacity(0.3), radius: 2, x: 0, y: 1)
    .offset(x: 32, y: 32)
  }
}

struct PauseButton: View {
  let game: GamePresenter
  var body: some View {
    Button("Pause") {
      game.isModalOpen = true
    }
    .btnStyle()
    .font(.title)
  }
}
