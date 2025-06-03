import Charts
import SwiftUI

struct EQLineChartData: Identifiable {
    let id = UUID() // Thêm ID để tuân thủ Identifiable
    let offset: Int
    let key: String
    var value: Double
}

@available(iOS 16, *)
struct ChartEqualizerView: View {
    @Binding var list: [EQLineChartData]
    let prevColor: Color
    let curColor: Color
    let curGradient: LinearGradient
    let yDomain: ClosedRange<Double>
    private let barWidth: CGFloat = 1.5
    private let symbolSize: CGFloat = 12
    private let chartHeight: CGFloat = 175
    private let minY: Double = -12
    private let maxY: Double = 12
    
    @State private var selectedEqualizer: String? = nil
    
    init(
        list: Binding<[EQLineChartData]>,
        prevColor: Color = Color(hue: 0.69, saturation: 0.19, brightness: 0.79),
        curColor: Color = Color(hue: 0.33, saturation: 0.81, brightness: 0.76),
        curGradient: LinearGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.5),
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.2),
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.05)
            ]),
            startPoint: .top,
            endPoint: .bottom
        ),
        yDomain: ClosedRange<Double> = -12...12
    ) {
        self._list = list
        self.prevColor = prevColor
        self.curColor = curColor
        self.curGradient = curGradient
        self.yDomain = yDomain
    }
    
    var body: some View {
        Chart {
            ForEach(list) { eq in
                BarMark(
                    x: .value("key", eq.key),
                    yStart: .value("equalizer", minY),
                    yEnd: .value("equalizer", maxY),
                    width: .fixed(barWidth)
                )
                .foregroundStyle(Color.clear)
                .annotation(position: .top, alignment: .center, spacing: 12) {
                    Text(String(format: "%.1f", eq.value))
                        .font(.caption2)
                        .foregroundStyle(Color(.systemGray).opacity(0.88))
                }
                
                AreaMark(
                    x: .value("key", eq.key),
                    yStart: .value("equalizer", eq.value),
                    yEnd: .value("equalizer", minY)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(curGradient)
                
                LineMark(
                    x: .value("key", eq.key),
                    y: .value("equalizer", eq.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(curColor)
                .symbol {
                    ZStack {
                        Circle().fill(.white)
                            .shadow(color: selectedEqualizer == eq.key ? curColor : .clear, radius: 3.5)
                        Circle().stroke(curColor, lineWidth: 2)
                    }
                    .frame(width: symbolSize)
                }
                .symbolSize(symbolSize)
            }
        }
        .padding(.vertical, 20)
        .chartYScale(domain: yDomain)
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(position: .bottom) {
                AxisValueLabel(verticalSpacing: 12)
                    .foregroundStyle(Color(.systemGray).opacity(0.88))
                    .font(.caption2)
                
                AxisGridLine(
                    centered: true,
                    stroke: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 0,
                        dashPhase: 0
                    )
                )
            }
        }
        .chartPlotStyle { plotArea in plotArea.background(Color.clear) }
        .frame(height: chartHeight)
        .background { Color.clear }
        .chartOverlay { chart in
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in handleDrag(value, chart: chart, geometry: geometry) }
                            .onEnded { _ in selectedEqualizer = nil }
                    )
            }
        }
    }
    
    private func handleDrag(_ value: DragGesture.Value, chart: ChartProxy, geometry: GeometryProxy) {
        let plotOrigin = geometry[chart.plotAreaFrame].origin
        let currentX = value.location.x - plotOrigin.x
        let currentY = value.location.y - plotOrigin.y
        guard currentX >= 0, currentX < chart.plotAreaSize.width else { return }
        guard currentY >= 0, currentY < chart.plotAreaSize.height else { return }
        guard let key: String = chart.value(atX: currentX) else { return }
        guard let yValue: Double = chart.value(atY: currentY) else { return }
        if selectedEqualizer == nil { withAnimation { selectedEqualizer = key } }
        if let selectedEqualizer = selectedEqualizer {
            if let index = list.firstIndex(where: { $0.key == selectedEqualizer }) {
                let clampedValue = max(minY, min(maxY, yValue))
                list[index].value = clampedValue
            }
        }
    }
}
