import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      GeometryReader { proxy in
        SquareView(id: UUID(), offset: CGSize(width: proxy.size.width / 1.5, height: 150))
          .opacity(0.3)
          .rotationEffect(Angle(degrees: 0))
          .animation(.easeInOut(duration: 2)
            .repeatForever(autoreverses: true))
        TriangleView(id: UUID(), offset: CGSize(width: 50, height: 150))
          .opacity(0.5)
          .rotationEffect(Angle(degrees: 16))
          .animation(.easeInOut(duration: 2)
            .repeatForever(autoreverses: true))
        CircleView(id: UUID(), offset: CGSize(width: 50, height: proxy.size.height / 2.5))
          .opacity(0.5)
          .rotationEffect(Angle(degrees: Double.random(in: 1 ... 180)))
          .animation(.easeInOut(duration: 2)
            .repeatForever(autoreverses: true))
        PentagonView(id: UUID(), offset: CGSize(width: proxy.size.width / 1.5, height: proxy.size.height / 1.5))
          .opacity(0.5)
          .rotationEffect(Angle(degrees: 20))
          .animation(.easeInOut(duration: 2)
            .repeatForever(autoreverses: true))
        VStack {
          Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 500)
            .padding(.bottom)
          NavigationLink(destination: SinglePlayerMenuView()) {
            Text("Single Player")
              .btnStyle()
          }
          .padding()
          NavigationLink(destination: MultiPlayerMenuView()) {
            Text("Multiplayer")
              .btnStyle()
          }
        }
        .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
      }
      .background(Color.main)
    }
    .navigationViewStyle(.stack)
  }
}
