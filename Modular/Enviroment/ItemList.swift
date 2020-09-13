//
//  ItemList.swift
//  Modular
//
//  Created by Justin Smith on 11/22/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import Foundation

struct ItemList<T:Equatable> : Equatable {
   
  init<S:Sequence> (_ s: S) where S.Element == Item<T> {
    self.store = zip(0...,s).reduce([:]) { (res, next) in
      let (seqIndex, item) = next
      guard !res.keys.contains(item.id) else { fatalError("ItemList initialized with a repeating ID")}
      
      var mutRes = res
      mutRes[item.id] = IndexGroup(item: item, index: seqIndex)
      return mutRes
    }
  }
  
  typealias ID = Item<T>.ID
   struct IndexGroup : Equatable{
    let item: Item<T>,index: Int
  }
  
  private var store: [ID:IndexGroup] = [:]
  var contents: [Item<T>] {
    get {
      return store.sorted { (tup1, tup2) -> Bool in
        tup1.value.index < tup2.value.index
        }.map{ val in
          return val.value.item
      }
    }
  }
  
  
  func getItem(id: ID ) -> Item<T>? {
    return store[id]?.item
  }
}

import ComposableArchitecture
extension IdentifiedArrayOf {
  mutating func addOrReplace(item: Element) {
   
    let existsAt = self.elements.firstIndex { (element) -> Bool in
      element[keyPath: self.id] ==  item[keyPath: self.id]
    }
  
    if let index = existsAt {
      self.remove(at: index)
      self.insert(item, at: index)
    }
    else {
      self.insert(item, at: self.elements.count)
    }
  }
  
}
//extension ItemList.IndexGroup : Codable where T : Codable { }
//extension ItemList : Codable where T : Codable { }


