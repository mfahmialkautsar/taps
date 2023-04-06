import SwiftUI

struct Arc: Shape {
  var startAngle: Angle
  var endAngle: Angle
  var clockwise: Bool

  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)

    return path
  }
}

struct CircleView: View {
  let id: UUID
  let offset: CGSize
  var group = 1
  var animation: Animation?
  let size: CGSize = CGSize(width: 150, height: 150)

  var body: some View {
    Arc(startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
      .foregroundColor(.green)
      .frame(width: size.width, height: size.height, alignment: .center)
      .offset(offset)
      .animation(animation, value: offset)
      .onAppear {
          while (true) {
              print("test")
          }
      }
  }
}
