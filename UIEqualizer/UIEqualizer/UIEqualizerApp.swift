import SwiftUI
@main
struct UIEqualizerApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

extension Color {
    static let empty: Color = Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.005))
}
