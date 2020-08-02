import Foundation
#if os(iOS)
import Singalong
#else
import SingalongMac
#endif


protocol Scaleable {}
public enum PointTag : Scaleable {} // Point
public typealias APoint = Tagged<PointTag,CGFloat>

public enum ExtentTag  : Scaleable  {} // Size
public typealias Extent = Tagged<ExtentTag,CGFloat>

public enum VectorTag  : Scaleable  {}
public typealias Vector = Tagged<VectorTag,CGFloat>

public struct ARect {
  public var origin: APoint
  public var size: Extent
}

extension Tagged where Tag : Scaleable, RawValue == CGFloat
{
  static func *(lhs: Tagged, rhs: CGFloat) -> Tagged
  {
    return lhs * Tagged(rawValue: rhs)
  }
}

extension CGPoint {
  init(x:APoint,y:APoint)
  {
    self.init(x: x.magnitude, y: y.magnitude)
  }
}

extension CGSize {
  init(width:Extent,height:Extent)
  {
    self.init(width: width.magnitude, height: height.magnitude)
  }
}

extension CGVector {
  init(dx:Vector,dy:Vector)
  {
    self.init(dx: dx.magnitude, dy: dy.magnitude)
  }
  
  
}
extension CGRect {
  init(x:APoint,y:APoint,width:Extent,height:Extent)
  {
    self.init(x: x.magnitude, y: y.magnitude,width: width.magnitude, height: height.magnitude)
  }
}



//
//func anExample() {
//
//  S2(offset: 3, size: 50, master: Rect(origin: 0, size: 3))
//  S2D(offset: CGPoint(0,0), size: CGSize(10,10), master: CGRect(x:0,y:0,width:10,height:10))
//  S3(bounds: 10, contentOffset: 0, contentSize: 10, master: Rect(origin: 0, size: 3))
//  O1(bounds: 10, outerOrigin: 0, outerSize: 10, origin: 1, size: 8)
//  I2(bounds: 10, largerOrigin: 0, largerSize: 10, smallerOrigin: 2, smallerSize: 8)
//}

//extension O1
//{
//  public init (i2: I2)
//  {
//    self.init(bounds: i2.bounds,
//              outerOrigin: i2.largerOrigin,
//              outerSize: i2.largerSize,
//              origin:  i2.smallerOrigin - i2.largerOrigin,
//              size: i2.smallerSize)
//  }
//}
//
extension O1 {
  public init( bounds: Height, s2: S2)
  {
    self.init(bounds: bounds, outerOrigin: -s2.offset, outerSize: s2.size, origin: s2.master.origin, size: s2.master.size)
  }
}

// Everything exists in the same cordinate system of bounds
//public struct I2: Equatable {
//  var bounds: Height
//  var largerOrigin : Point
//  var largerSize: Height
//  var smallerOrigin : Point
//  var smallerSize : Point
//}


//
extension S3{
  public init (_ o1: O1)
  {
    self.init(bounds: o1.bounds, contentOffset: -o1.outerOrigin, contentSize: o1.outerSize, master: Rect(origin: o1.origin, size: o1.size))
  }
}
//extension I2
//{
//  public init (o1: O1)
//  {
//    self.init(bounds: o1.bounds,
//              largerOrigin: o1.outerOrigin,
//              largerSize: o1.outerSize,
//              smallerOrigin: o1.outerOrigin + o1.origin,
//              smallerSize: o1.size)
//  }
//}
