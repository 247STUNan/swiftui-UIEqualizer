import SwiftUI
import RealmSwift
@available(iOS 16, *)
struct ContainerEQView: View {
  @AppStorage("isChartStyle") private var isChartStyle: Bool = false
  @State private var isDisableView: Bool = false
  @State private var isPresentCreate: Bool = false
  @State private var tfPresentCreate: String = ""

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
  @State private var selectedKey: String? = nil
  @ObservedResults(EQDataContainer.self, sortDescriptor: SortDescriptor(keyPath: "index", ascending: true))
  var listEQualizerPresent
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        VStack(spacing: 0) {
          Divider()
            .padding(.bottom, 4)

          if isChartStyle {
            ChartEqualizerView(list: $list)
              .padding(.vertical, 8)
              .padding(.bottom, 4)
          } else {
            ToggleEQualizerView(list: $list)
              .padding(.vertical, 8)
              .padding(.bottom, 4)
          }

          VStack(spacing: 0) {
            VStack(spacing: 0) {
              PlayerButton(label: {
                Text("eq.key")
                  .padding(.vertical, 4)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.leading, 6)
              }) {

              }
              .padding(.horizontal)
              .background { Color.empty }
              .allowsHitTesting(false)
              .disabled(true)
              .opacity(0.005)
            }
            .background { Color.background }
            .overlay {
              Text("My Presents").padding(.leading, 6).frame(maxWidth: .infinity, alignment: .leading).font(.headline)
            }
            .overlay(alignment: .bottom) { Divider() }

            List {
              ForEach(listEQualizerPresent) { eq in
                PlayerButton(label: {
                  Text("\(eq.key)")
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 6)
                    .foregroundStyle(selectedKey == eq.key ? Color.blue : Color.black)
                }) {
                  apply(eq: eq)
                }
                .padding(.horizontal)
                .background { Color.empty }
              }
              .onDelete(perform: onDelete)
              .onMove(perform: onMove)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
          .playerButtonStyle(.equalizerPlayer)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .disabled(!isDisableView)
        .opacity(!isDisableView ? 0.68 : 1)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .navigationTitle(isChartStyle ? "Chart Equalizer" : "Toggle Equalizer")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarTitleMenu {
          Button(action: {
            isChartStyle = true
          }, label: {
            HStack {
              Text("Chart Equalizer")

              Spacer()

              if isChartStyle { Image(systemName: "checkmark") }
            }
          })

          Button(action: {
            isChartStyle = false
          }, label: {
            HStack {
              Text("Toggle Equalizer")

              Spacer()

              if !isChartStyle { Image(systemName: "checkmark") }
            }
          })

          Button(action: {
            isPresentCreate = true
          }, label: {
            HStack {
              Text("Create Equalizer")

              Spacer()

              Image(systemName: "plus")
            }
          })
        }

        ToolbarItem(placement: .topBarLeading) {
          Button {
            EQDataContainer.snapListDefailts()
          } label: {
            Image(systemName: "arrow.backward")
              .resizable()
              .scaledToFit()
              .font(.caption)
              .frame(width: 14, height: 14)
              .foregroundStyle(.blue)
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Toggle(isOn: $isDisableView) { }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .fixedSize()
            .scaleEffect(0.8)
        }
      }
      .background { Color.background }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background { Color.background }
    .onAppear { EQDataContainer.snapListDefailts() }
    .alert("Present Equalizer",isPresented: $isPresentCreate, actions: {
      TextField("Enter your name equalizer..", text: $tfPresentCreate)

      Button("OK") {
        if saveEQToPresents(name: tfPresentCreate, eq: list) {
          withAnimation {
            isPresentCreate = false
            tfPresentCreate = ""
          }
        }
      }

      Button("Cancel", role: .cancel) { }
    })
  }


  func onDelete(at offsets: IndexSet) {

  }

  func onMove(from source: IndexSet, to destination: Int) {

  }

  func apply(eq: EQDataContainer) {
    withAnimation(.bouncy) {
      selectedKey = eq.key
      for eqData in eq.listEQ {
        if let index = list.firstIndex(where: { $0.key == eqData.key }) {
          list[index].offset = eqData.offset
          list[index].value = eqData.value
        }
      }
    }
  }

  func saveEQToPresents(name: String, eq: [EQLineChartData]) -> Bool {
    if EQDataContainer.isExist(key: name) == false {
      guard let realm = try? Realm() else { return true }
      try? realm.write {
        var eqList: [EQLineChartDataObject] = []
        for eqData in eq {
          let eqObject = EQLineChartDataObject(offset: eqData.offset, key: eqData.key, value: eqData.value)
          eqList.append(eqObject)
        }
        let container = EQDataContainer(key: name, status: .sys, listEQ: eqList.map { $0 })
        realm.add(container)
      }
      return true
    } else {
      return false
    }
  }
}
