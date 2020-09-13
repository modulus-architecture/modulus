//
//  Mock.swift
//  Modular
//
//  Created by Justin Smith on 11/22/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import Foundation
import GrapheNaked
import Singalong

extension ScaffGraph {
   init() {
    let initial = CGSize3(width: 300, depth: 100, elev: 400) |> createNusGrid
    self.init(id:"Mock", grid: initial.0, edges: initial.1)
  }
  
   init(grid:GraphPositions, edges:[ScaffEdge]) {
     self.init(id:"Mock", grid: grid, edges: edges)
  }
  
  static var mock : ScaffGraph = CGSize3(width: 300, depth: 100, elev: 400) |> createNusGrid >>> curry(ScaffGraph.init)("Mock")
}

extension Item where Content == ScaffGraph {
  static var mock : Item<Content> = Item(content:ScaffGraph.mock, name: "First Graph")
}

let defaultSizes = ScaffoldingGridSizes.mock.map{$0.centimeters}
let standardStack = curriedScaffoldingFrom(defaultSizes)


extension ScaffGraph {
  static var mockList : Array<Item<ScaffGraph>> = {
    var list = [
      Item(content: (100,100,450) |> CGSize3.init |> curriedScaffoldingFrom(defaultSizes), name: "None Graph"),
      Item(content: (1000,1000,100) |> CGSize3.init |> curriedScaffoldingFrom(defaultSizes), name: "Four by Eight"),
      Item(content: (500,1000,1000) |> CGSize3.init |> curriedScaffoldingFrom(defaultSizes), name: "Third Graph")]
    return list
  }()
}

extension StandardEditingViews {
  static var mock = StandardEditingViews()
}

extension Environment {
  static var mock = Environment(
    file: .mock,
    thumbnails: ThumbnailIO(),
    screen: CGRect(0,0,300, 600),
    viewMaps: .mock)
}
