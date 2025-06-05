import SwiftUI
extension View {
    func modify<T: View>(@ViewBuilder _ transform: (Self) -> T) -> some View {
        transform(self)
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping() -> Content ) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
