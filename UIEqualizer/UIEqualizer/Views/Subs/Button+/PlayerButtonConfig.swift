import Foundation
import SwiftUI
struct DeboucdePlayerButtonConfig {
  let updateUnterval: TimeInterval
  @State var isEnabled: Bool = false
  init(
    updateUnterval: TimeInterval = 0.25
  ) {
    self.updateUnterval = updateUnterval
  }
}

extension EnvironmentValues {
    var playerButtonConfig: DeboucdePlayerButtonConfig {
        get { self[PlayerButtonConfigEnvironmentKey.self] }
        set { self[PlayerButtonConfigEnvironmentKey.self] = newValue }
    }
}

private struct PlayerButtonConfigEnvironmentKey: EnvironmentKey {
    static let defaultValue: DeboucdePlayerButtonConfig = .init()
}

extension View {
    func playerButtonStyle(_ config: DeboucdePlayerButtonConfig) -> some View {
        environment(\.playerButtonConfig, config)
    }
}

extension DeboucdePlayerButtonConfig {
    static var equalizerPlayer: Self {
        Self(
            updateUnterval: TimeInterval(1.25)
        )
    }
}
