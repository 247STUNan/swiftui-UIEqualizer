import SwiftUI
struct PlayerButton<Content: View>: View {
  @Environment(\.playerButtonConfig) var config
  @State private var showCircle = false
  @State private var pressed = false
  @State private var pressedDebouce = false
  @GestureState private var startTimestamp: Date?
  private let label: Content
  private var onEnded: () -> Void

  init(
    label: (() -> Content),
    onEnded: @escaping () -> Void
  ) {
    self.label = label()
    self.onEnded = onEnded
  }

  var body: some View {
    label
      .background(Color.empty)
      .onTapGesture {
        blockPress(withTimeInterval: config.updateUnterval)
        onEnded()
      }
      .clipShape(RoundedRectangle(cornerRadius: 5))
      .disabled(pressedDebouce)
      .opacity(pressedDebouce ? 0.78 : 1)
  }

  func blockPress(withTimeInterval: TimeInterval) {
    withAnimation(.spring) {
      pressedDebouce = true
      Timer.scheduledTimer(withTimeInterval: withTimeInterval, repeats: false) { _ in
        pressedDebouce = false
      }
    }
  }
}
