import Foundation
import RealmSwift
class EQDataContainer: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var key: String = UUID().uuidString
  @Persisted var index: Int = 0
  @Persisted var listEQ = List<EQLineChartDataObject>()
  @Persisted(indexed: true) var status: PStatus = .custom
  convenience init(key: String, status: PStatus, listEQ: [EQLineChartDataObject]) {
    self.init()
    self.key = key
    self.status = status
    self.listEQ.append(objectsIn: listEQ)
    let realm = try? Realm()
    self.index = (realm?.objects(EQDataContainer.self).max(of: \.index) ?? 0) + 1
  }

  enum PStatus: String, PersistableEnum {
    case custom
    case sys
  }
}

@objc(EQLineChartDataObject)
class EQLineChartDataObject: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: UUID
  @Persisted var offset: Int
  @Persisted var key: String
  @Persisted var value: Double

  convenience init(offset: Int, key: String, value: Double) {
    self.init()
    self.id = UUID()
    self.offset = offset
    self.key = key
    self.value = value
  }
}


extension EQDataContainer {
  static func snapListDefailts() {
    guard let realm = try? Realm() else { return }
    try? realm.write {
      for eqCache in EQCache.default {
        if let _ = realm.object(ofType: EQDataContainer.self, forPrimaryKey: eqCache.key) { return }
        else {
          let eqList = List<EQLineChartDataObject>()
          for eqData in eqCache.listEQ {
            let eqObject = EQLineChartDataObject(offset: eqData.offset, key: eqData.key, value: eqData.value)
            eqList.append(eqObject)
          }
          let container = EQDataContainer(key: eqCache.key, status: .sys, listEQ: eqList.map { $0 })
          realm.add(container)
        }
      }
    }
  }

  static func isExist(key: String) -> Bool {
    guard let realm = try? Realm() else { return false }
    if let _ = realm.object(ofType: EQDataContainer.self, forPrimaryKey: key) { return true }
    return false
  }
}
