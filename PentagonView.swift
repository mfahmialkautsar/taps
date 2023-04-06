import SwiftUI

public struct PentagonShape: Shape {
  public init() {}

  var insetAmount: CGFloat = 0

  public func path(in rect: CGRect) -> Path {
    let insetRect: CGRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
    let w = insetRect.width
    let h = insetRect.height

    return Path { path in
      path.move(to: CGPoint(x: w / 2, y: 0))
      path.addLine(to: CGPoint(x: 0, y: h / 2))
      path.addLine(to: CGPoint(x: w / 5, y: h))
      path.addLine(to: CGPoint(x: w / 1.25, y: h))
      path.addLine(to: CGPoint(x: w, y: h / 2))
      path.closeSubpath()
    }
    .offsetBy(dx: insetAmount, dy: insetAmount)
  }
}

extension PentagonShape: InsettableShape {
  public func inset(by amount: CGFloat) -> some InsettableShape {
    var shape = self
    shape.insetAmount += amount
    return shape
  }
}

struct PentagonView: View {
  let id: UUID
  let offset: CGSize
  var group = 1
  var animation: Animation?
  let size: CGSize = CGSize(width: 150, height: 150)

  var body: some View {
    PentagonShape()
      .fill(.blue)
      .frame(width: size.width, height: size.height, alignment: .center)
      .offset(offset)
      .animation(animation, value: offset)
  }
}
