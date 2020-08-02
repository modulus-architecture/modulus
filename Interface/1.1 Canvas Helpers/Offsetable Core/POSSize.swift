import Foundation
#if os(iOS)
import Geo
import Singalong
#else
import MacGeo
import SingalongMac
#endif


public typealias Height = CGFloat
public typealias Offset = CGFloat
public typealias Point = CGFloat
public typealias Frame = (Point, Height)


public struct Rect : Equatable {
  public var origin: Point
  public var size : Height
}


public typealias Bounds = CGFloat

public struct PosSize1D
{
  public var size : Height
  public var padding : Height // x2, Applied at top and at bottom
  public var scale : CGFloat
  
  public var boundary: Height
  public var contentOrigin : Point
  public var contentSize: Height
  
  public init(size: Height,
              padding: Height,
              scale: CGFloat,
              boundary: Height,
              contentOrigin: Point,
              contentSize: Height)
  {
    self.size = size
    self.padding = padding
    self.scale  = scale
    self.boundary = boundary
    self.contentOrigin = contentOrigin
    self.contentSize = contentSize
  }
}

// (O1) -> PosSize1D
// (PosSize1D) -> O1

extension PosSize1D
{
  public init(o1: O1)
  {
    self.size = o1.size
    self.padding = o1.origin // TODO : Check all padding is the same
    self.scale  = 1.0
    self.boundary = o1.bounds
    self.contentOrigin = o1.outerOrigin
    self.contentSize = o1.outerSize
  }
}


// PaddedOffsetScaleableSize
// PosSize
public struct PosSize
{
  
  public var size : CGSize
  public var padding : CGFloat // x2, Applied at top and at bottom
  public var scale : CGFloat
  
  public var boundary: CGSize
  public var contentOrigin : CGPoint
  public var contentSize: CGSize
  
  public init(size: CGSize,
              padding: CGFloat,
              scale: CGFloat,
              boundary: CGSize,
              contentOrigin: CGPoint,
              contentSize: CGSize)
  {
    self.size = size
    self.padding = padding
    self.scale  = scale
    self.boundary = boundary
    self.contentOrigin = contentOrigin
    self.contentSize = contentSize
  }
}




