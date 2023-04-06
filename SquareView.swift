import SwiftUI

struct SquareView: View {
  let id: UUID
  let offset: CGSize
  var group = 1
  var animation: Animation?
  let size: CGSize = CGSize(width: 150, height: 150)

  var body: some View {
    Rectangle()
      .fill(.yellow)
      .frame(width: size.width, height: size.height, alignment: .center)
      .offset(offset)
      .animation(animation, value: offset)
  }
}
