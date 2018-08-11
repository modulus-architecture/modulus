//
//  ViewFunctions.swift
//  HandlesRound1
//
//  Created by Justin Smith on 2/10/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import CoreGraphics
import Singalong
import Geo
import GrippableView
import Graphe
import BlackCricket

func log<A>(_ loggableItem: A) -> A
{
  print(loggableItem)
  return loggableItem
}

func logDescription<A>(_ loggableItem: A, description: (A)->String) -> A
{
  print(description(loggableItem))
  return loggableItem
}



let remove3rdDim : (CGSize3) -> CGSize = {
  return CGSize(width: $0.width, height:  $0.elev)
}
let remove3rdDimSide : (CGSize3) -> CGSize = {
  return CGSize(width: $0.depth, height:  $0.elev)
}
let remove3rdDimPlan : (CGSize3) -> CGSize = {
  return CGSize(width: $0.width, height:  $0.depth)
}


func bindSize( master: CGRect, size: CGSize, positions: (VerticalPosition, HorizontalPosition)) -> (CGRect)
{
  // Find Orirgin
  return master.withInsetRect( ofSize: size, hugging:  (positions.0.oposite, positions.1.oposite))
}

func centeredRect( master: CGRect, size: CGSize, positions: (VerticalPosition, HorizontalPosition)) -> (CGRect)
{
  // Find Orirgin
  return master.withInsetRect( ofSize: size, hugging:  positions)
}



//

let sizeFromPlanScaff : (ScaffGraph) -> CGSize = { $0.bounds } >>> remove3rdDimPlan
let sizeFromRotatedPlanScaff : (ScaffGraph) -> CGSize = { $0.bounds } >>> remove3rdDimPlan >>> flip
let sizeFromGridScaff : (ScaffGraph) -> CGSize = { $0.boundsOfGrid.0 } >>> remove3rdDim
let sizeFromFullScaff : (ScaffGraph) -> CGSize = { $0.bounds } >>> remove3rdDim
let sizeFromFullScaffSide : (ScaffGraph) -> CGSize = { $0.bounds } >>> remove3rdDimSide

let schematicSize : (ScaffGraph) -> CGSize3 = {
  CGSize3(width: CGFloat($0.grid.pX.count * 100),
          depth: CGFloat($0.grid.pY.count * 100),
          elev: CGFloat($0.grid.pZ.count * 100))
}
let sizeSchematicFront : (ScaffGraph) -> CGSize = schematicSize >>> remove3rdDim




func originSwap(origin: CGRect, height: CGFloat) -> CGPoint
{
  return CGPoint(origin.x, height - origin.y - origin.height)
}

let originFromGridScaff : (ScaffGraph, CGRect, CGFloat) -> CGPoint =
{ (scaff, newRect, boundsHeight) in
  // Find Orirgin
  var origin = (newRect, boundsHeight) |> originSwap
 return ((origin, unitY * -scaff.boundsOfGrid.1) |>  moveByVector)
}
let originFromFullScaff : (ScaffGraph, CGRect, CGFloat) -> CGPoint =
{ (graph, newRect, boundsHeight) in
  // Find Orirgin
  
  return (newRect, boundsHeight) |> originSwap

}


let rotateGroup : ([C2Edge]) -> [C2Edge] = { $0.map(rotate) }
func rotate( edge: C2Edge) -> C2Edge {
  return C2Edge(content: edge.content, p1: edge.p1 |> flip, p2: edge.p2 |> flip )
}
func flip( point: CGPoint) -> CGPoint
{
  return CGPoint(point.y, point.x)
}
func flip( size: CGSize) -> CGSize
{
  return CGSize(size.height, size.width)
}


// 2D Dim Plan grid stuff ...
func graphToNonuniformPlan(gp: GraphPositions) -> NonuniformModel2D
{
  return NonuniformModel2D(origin: CGPoint.zero, rowSizes: Grid(gp.pY |> posToSeg), colSizes: Grid(gp.pX |> posToSeg))
}
let graphToPlanDimGeometry = graphToNonuniformPlan >>> basic


func edgesToPoints(edges: [C2Edge]) -> [CGPoint]
{
  
  let cgPoints = edges.flatMap {
    c2Edge -> [CGPoint] in
    return [c2Edge.p1, c2Edge.p2]
  }
  return cgPoints
}

 func removeDup<A : Equatable> (edges: [A]) -> [A]
{
  return edges.reduce([])
  {
    res, next in
    guard !res.contains(next) else { return res }
    return res + [next]
  }
}

 func leftToRightDict(points: [CGPoint]) -> [CGFloat : [CGFloat]]
{
  let yOrientedDict : [CGFloat : [CGFloat] ] = [ :]
  let pointDict = points.reduce(yOrientedDict) {
    (res, next) in
    var newRes = res
    let arr = newRes[next.y] ?? []
    newRes[next.y] =  arr +  [next.x]
    return newRes
  }
  return pointDict
}

func pointDictToArray( dict: [CGFloat : [CGFloat]] ) -> [[CGPoint]]
{
  return dict.keys.sorted().map {
    key in
   return  dict[key]!.map { value in
      return CGPoint(value, key)
    }
  }
}

func graphToNonuniformFront(gp: GraphPositions) -> NonuniformModel2D
{
    return NonuniformModel2D(origin: CGPoint.zero, rowSizes: Grid(gp.pZ |> posToSeg), colSizes: Grid(gp.pX |> posToSeg))
}
func graphToNonuniformSide(gp: GraphPositions) -> NonuniformModel2D
{
  return NonuniformModel2D(origin: CGPoint.zero, rowSizes: Grid(gp.pZ |> posToSeg), colSizes: Grid(gp.pY |> posToSeg))
}
struct GraphPositionsOrdered2D
{
  let x: [CGFloat]
  let y: [CGFloat]
  init (x: [CGFloat], y: [CGFloat]) {
    self.x = x.sorted()
    self.y = y.sorted()
  }
}

func graphToFrontGraph2D(gp: GraphPositions) -> (GraphPositionsOrdered2D)
{
  return GraphPositionsOrdered2D(x: gp.pX, y: gp.pZ)
}
func graphToCorners(gp: GraphPositionsOrdered2D) -> Corners
{
  return (top: gp.y.last!, right: gp.x.last!, bottom: gp.y.first!, left: gp.x.first!)
}



let graphToDefPlanEdges : (ScaffGraph)->[C2Edge] = { $0.planEdgesNoZeros }

let planGridsToDimensions : (ScaffGraph) -> [Geometry] = { $0.grid } >>> graphToNonuniformPlan >>> basic
// ... End 2d dim plan gridd stuf
let graphToTextures :  (ScaffGraph) -> [Geometry] = { $0.planEdgesNoZeros } >>> planEdgeToGeometry >>> map(toGeometry)
let graphToNonuniform : (ScaffGraph) -> NonuniformModel2D = { $0.grid } >>> graphToNonuniformPlan

// (A -> B, C ) (B, C) -> D
let nonuniformToDimensions : (NonuniformModel2D) -> [Geometry] = (nonuniformToPoints, 40) >>-> pointCollectionToDimLabel >>> map(toGeometry)
// (A -> B -> C) (C -> D)
// (T -> C) (C -> D)
//func >>><A, B, C, D>(f: (A)->(B)->C, g:(C)->D ) -> (A)->(B)->(D)
//{
//  { f in return {p in f(p) |> nonuniformToDimensions }
//}
//let graphToDimensions = graphToNonuniform >>> { f in return {p in f(p) |> nonuniformToDimensions }  }
let graphToDimensions : (ScaffGraph) -> [Geometry] = graphToNonuniform >>> nonuniformToDimensions

let finalDimComp : (ScaffGraph) -> [Geometry] = graphToTextures <> graphToDimensions
let rotatedPlanGrid : (ScaffGraph) -> [Geometry] = graphToDefPlanEdges >>> rotateGroup >>> planEdgeToGeometry >>> map(toGeometry)

func rotateUniform(nu: NonuniformModel2D)-> NonuniformModel2D
  {
    return NonuniformModel2D(origin: nu.origin, rowSizes: nu.colSizes, colSizes: nu.rowSizes)
}
let rotatedPlanDim : (ScaffGraph) -> [Geometry] = graphToNonuniform >>> rotateUniform >>> nonuniformToDimensions
let rotatedFinalDimComp : (ScaffGraph) -> [Geometry] = rotatedPlanGrid <> rotatedPlanDim

