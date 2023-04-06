import SwiftUI

extension View {
  func btnStyle() -> some View {
    return padding(24)
      .font(.largeTitle)
      .foregroundColor(.mainBlack)
      .background(Color.white)
      .cornerRadius(25)
      .shadow(color: .secondary.opacity(0.3), radius: 2, x: 0, y: 1)
  }
}
