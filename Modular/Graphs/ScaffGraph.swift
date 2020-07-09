//
//  ScaffGraph.swift
//  HandlesRound1
//
//  Created by Justin Smith on 3/2/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import CoreGraphics
import Singalong
import GrapheNaked
import Interface


public struct ScaffGraph : Equatable, GraphHolder {
  public var id: String
  
  public init(id: String, grid: GraphPositions, edges:[ScaffEdge]) {
    self.id = id
    self.grid = grid
    self.edges = edges
  }
  public var grid : GraphPositions
  public var edges : [ScaffEdge]
  
  mutating func addEdge(_ cedge : CEdge<ScaffType>) {
    let new = (grid, cedge) |> add
    grid = new.0
    edges.append(new.1)
  }
}




extension ScaffGraph : Codable {
  
}

