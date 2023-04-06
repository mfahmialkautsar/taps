import SwiftUI

struct TriangleShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

    return path
  }
}

struct TriangleView: View {
  let id: UUID
  let offset: CGSize
  var group = 1
  var animation: Animation?
  let size: CGSize = CGSize(width: 150, height: 150)

  var body: some View {
    TriangleShape()
      .fill(.red)
      .frame(width: size.width, height: size.height, alignment: .center)
      .offset(offset)
      .animation(animation, value: offset)
  }
}
