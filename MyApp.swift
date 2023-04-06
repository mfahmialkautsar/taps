import SwiftUI

@main
struct MyApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
    }
  }
}
