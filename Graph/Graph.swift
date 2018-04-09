//: Playground - noun: a place where people can play

import CoreGraphics

struct GraphSegments
{
  var sX : [CGFloat]
  var sY : [CGFloat]
  var sZ : [CGFloat]
}

struct GraphPositions
{
  var pX : [CGFloat]
  var pY : [CGFloat]
  var pZ : [CGFloat]
}

struct GraphPositionsSorted
{
  let pX : [CGFloat]
  let pY : [CGFloat]
  let pZ : [CGFloat]
  
  init(pX : [CGFloat],
       pY : [CGFloat],
       pZ : [CGFloat]
    ) {
    self.pX = pX.sorted()
    self.pY = pY.sorted()
    self.pZ = pZ.sorted()
  }
}
struct GraphPositions2DSorted
{
  let pX : [CGFloat]
  let pY : [CGFloat]
  
  init(pX : [CGFloat],
       pY : [CGFloat]
    ) {
    self.pX = pX.sorted()
    self.pY = pY.sorted()
  }
}


struct PointIndex : Equatable { let xI, yI, zI : Int }


struct Edge
{
  var content : EdgeType
  var p1 : PointIndex
  var p2 : PointIndex
}

struct EdgeEmpty // Without Content
{
  var p1 : PointIndex
  var p2 : PointIndex
}

extension Edge
{
  init( content: EdgeType, p1: (Int, Int, Int), p2: (Int, Int, Int) )
  {
    self.content = content
    self.p1 = p1 |> PointIndex.init
    self.p2 = p2 |> PointIndex.init
  }
}

extension Edge : Equatable {
  static func == (lhs: Edge, rhs: Edge) -> Bool {
    return lhs.empty == rhs.empty
  }
  var empty : EdgeEmpty { get { return EdgeEmpty(p1: self.p1, p2: self.p2)} }
}

extension EdgeEmpty : Equatable {
  static func == (lhs: EdgeEmpty, rhs: EdgeEmpty) -> Bool {
    return (lhs.p1 == rhs.p1 && lhs.p2 == rhs.p2) ||
      (lhs.p1 == rhs.p2 && lhs.p2 == rhs.p1)
  }
}

struct Point3 {
  var (x, y, z) : (CGFloat,CGFloat,CGFloat)
}

struct Segment3 {
  var (p1, p2) : (Point3, Point3)
}

struct CEdge
{
  var content : EdgeType
  var p1 : Point3
  var p2 : Point3
}

enum EdgeType : String {
  case ledger = "Ledger"
  case diag = "Diag"
  case bc = "BC"
  case standardGroup = "StandardGroup"
  case jack = "Jack"
}


struct C2Edge : Equatable{
  var content : EdgeType
  var (p1,p2) : (CGPoint, CGPoint)
  
  static func ==(lhs: C2Edge, rhs: C2Edge) -> Bool
  {
    let pointsEqual = (lhs.p1 == rhs.p1 && lhs.p2 == rhs.p2)
      || (lhs.p1 == rhs.p2 && lhs.p2 == rhs.p1)
    return lhs.content == rhs.content && pointsEqual
  }
}





struct CGSize3 { var (width, depth, elev) : (CGFloat, CGFloat, CGFloat) }



typealias SGraph = (GraphPositions, [Edge])
struct Parse<A>
{
  let parse: (SGraph) -> (A)
}

extension Edge : CustomStringConvertible {
  var description : String { return "\(p1.xI),\(p1.yI),\(p1.zI), -> \(p2.xI),\(p2.yI),\(p2.zI)    : \(content) \(p2.zI - p1.zI) \n"}
}

extension Point3 : CustomStringConvertible {
  var description : String { return "\(x), \(y), \(z)"}
}

extension CEdge : CustomStringConvertible {
  var description : String { return "\(content) \(p1), -> \t\t\t \(p2)\n"}
}
extension Segment3 : CustomStringConvertible {
  var description : String { return "\(p1), -> \t\t\t \(p2)\n"}
}
extension C2Edge : CustomStringConvertible {
    var description : String { return "\(content) \(p1), -> \t\t\t \(p2)\n"}
}
