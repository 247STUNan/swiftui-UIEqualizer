import SwiftUI
struct EQCache {
  let offset: Int
  let key: String
  let listEQ: [EQLineChartData]
}
struct EQLineChartData: Identifiable {
  let id = UUID()
  var offset: Int
  var key: String
  var value: Double
}

extension EQCache {
  static let `default`: [EQCache] = [
    EQCache(offset: 0, key: "Acoustic", listEQ: [
      EQLineChartData(offset: 0, key: "32Hz", value: 10.0),
      EQLineChartData(offset: 0, key: "64Hz", value: 10.0),
      EQLineChartData(offset: 0, key: "125Hz", value: 8.0),
      EQLineChartData(offset: 0, key: "250Hz", value: 2.0),
      EQLineChartData(offset: 0, key: "500Hz", value: 4.0),
      EQLineChartData(offset: 0, key: "1KHz", value: 4.0),
      EQLineChartData(offset: 0, key: "2KHz", value: 8.0),
      EQLineChartData(offset: 0, key: "4KHz", value: 10.0),
      EQLineChartData(offset: 0, key: "8KHz", value: 8.0),
      EQLineChartData(offset: 0, key: "16KHz", value: 4.0)
    ]),
    EQCache(offset: 1, key: "Electronic", listEQ: [
      EQLineChartData(offset: 1, key: "32Hz", value: 10.0),
      EQLineChartData(offset: 1, key: "64Hz", value: 8.0),
      EQLineChartData(offset: 1, key: "125Hz", value: 2.0),
      EQLineChartData(offset: 1, key: "250Hz", value: 0.0),
      EQLineChartData(offset: 1, key: "500Hz", value: -4.0),
      EQLineChartData(offset: 1, key: "1KHz", value: 4.0),
      EQLineChartData(offset: 1, key: "2KHz", value: 2.0),
      EQLineChartData(offset: 1, key: "4KHz", value: 2.0),
      EQLineChartData(offset: 1, key: "8KHz", value: 8.0),
      EQLineChartData(offset: 1, key: "16KHz", value: 10.0)
    ]),
    EQCache(offset: 2, key: "Latin", listEQ: [
      EQLineChartData(offset: 2, key: "32Hz", value: 10.0),
      EQLineChartData(offset: 2, key: "64Hz", value: 6.0),
      EQLineChartData(offset: 2, key: "125Hz", value: 0.0),
      EQLineChartData(offset: 2, key: "250Hz", value: 0.0),
      EQLineChartData(offset: 2, key: "500Hz", value: -2.0),
      EQLineChartData(offset: 2, key: "1KHz", value: -2.0),
      EQLineChartData(offset: 2, key: "2KHz", value: -2.0),
      EQLineChartData(offset: 2, key: "4KHz", value: 2.0),
      EQLineChartData(offset: 2, key: "8KHz", value: 6.0),
      EQLineChartData(offset: 2, key: "16KHz", value: 10.0)
    ]),
    EQCache(offset: 3, key: "Pop", listEQ: [
      EQLineChartData(offset: 3, key: "32Hz", value: -4.0),
      EQLineChartData(offset: 3, key: "64Hz", value: -2.0),
      EQLineChartData(offset: 3, key: "125Hz", value: 0.0),
      EQLineChartData(offset: 3, key: "250Hz", value: 4.0),
      EQLineChartData(offset: 3, key: "500Hz", value: 10.0),
      EQLineChartData(offset: 3, key: "1KHz", value: 10.0),
      EQLineChartData(offset: 3, key: "2KHz", value: 4.0),
      EQLineChartData(offset: 3, key: "4KHz", value: 0.0),
      EQLineChartData(offset: 3, key: "8KHz", value: -1.0),
      EQLineChartData(offset: 3, key: "16KHz", value: -2.0)
    ]),
    EQCache(offset: 4, key: "Rock", listEQ: [
      EQLineChartData(offset: 4, key: "32Hz", value: 10.0),
      EQLineChartData(offset: 4, key: "64Hz", value: 8.0),
      EQLineChartData(offset: 4, key: "125Hz", value: 6.0),
      EQLineChartData(offset: 4, key: "250Hz", value: 3.0),
      EQLineChartData(offset: 4, key: "500Hz", value: 0.0),
      EQLineChartData(offset: 4, key: "1KHz", value: -1.0),
      EQLineChartData(offset: 4, key: "2KHz", value: 1.0),
      EQLineChartData(offset: 4, key: "4KHz", value: 6.0),
      EQLineChartData(offset: 4, key: "8KHz", value: 10.0),
      EQLineChartData(offset: 4, key: "16KHz", value: 12.0)
    ]),
    EQCache(offset: 5, key: "Bass", listEQ: [
      EQLineChartData(offset: 5, key: "32Hz", value: 12.0),
      EQLineChartData(offset: 5, key: "64Hz", value: 8.0),
      EQLineChartData(offset: 5, key: "125Hz", value: 7.0),
      EQLineChartData(offset: 5, key: "250Hz", value: 5.0),
      EQLineChartData(offset: 5, key: "500Hz", value: 2.0),
      EQLineChartData(offset: 5, key: "1KHz", value: 0.0),
      EQLineChartData(offset: 5, key: "2KHz", value: 0.0),
      EQLineChartData(offset: 5, key: "4KHz", value: 0.0),
      EQLineChartData(offset: 5, key: "8KHz", value: 0.0),
      EQLineChartData(offset: 5, key: "16KHz", value: 0.0)
    ])
  ]
}
