import SwiftUI

struct ContentView: View {
    @State private var list: [EQLineChartData] = [
        .init(offset: 1, key: "32Hz", value: 10.0),
        .init(offset: 2, key: "64Hz", value: 6.0),
        .init(offset: 3, key: "125Hz", value: 12.0),
        .init(offset: 4, key: "250Hz", value: 8.0),
        .init(offset: 5, key: "500Hz", value: 9.0),
        .init(offset: 6, key: "1KHz", value: 2.0),
        .init(offset: 7, key: "2KHz", value: 12.0),
        .init(offset: 8, key: "4KHz", value: -2.0),
        .init(offset: 9, key: "8KHz", value: -6.0),
        .init(offset: 10, key: "16KHz", value: -10.0),
    ]
    var body: some View {
        VStack {
            ChartEqualizerView(list: $list)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
