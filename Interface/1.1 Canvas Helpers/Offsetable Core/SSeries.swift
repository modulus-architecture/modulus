import CoreGraphics

public struct S2 : Equatable{
  /// Exterior Offset
  public var offset : Offset
  /// Exterior Size
  public var size : Height
  /// Interior Rect
  public var master: Rect
  
  public init(offset : Offset, size : Height, master: Rect)
  {
    (self.offset, self.size, self.master)  = (offset, size, master)
  }
}

extension S2 {
  public init (o1: O1)
  {
    self.init(offset: -o1.outerOrigin,
              size: o1.outerSize,
              master: Rect(origin: o1.origin , size: o1.size))
  }
  
  public init (s3: S3)
  {
    self.init(offset: s3.contentOffset,
              size: s3.contentSize,
              master: Rect(origin: s3.master.origin , size: s3.master.size))
  }
}

public func s2Scaled(scale: CGFloat)->(S2)->S2
{
  return { s2 in
    var r2 = s2
    r2.master.origin = s2.master.origin * scale
    r2.master.size = s2.master.size * scale
    r2.offset = s2.offset * scale
    r2.size = s2.size * scale
    return r2
  }
}

public struct S2D {
  public var offset : CGPoint
  public var size : CGSize
  public var master: CGRect
  
  public init(offset: CGPoint, size: CGSize, master: CGRect)
  {
    (self.offset, self.size, self.master) = (offset,size,master)
  }
}


public struct S3 {
  public var bounds: Height
  public var contentOffset : Offset
  public var contentSize : Height
  public var master: Rect
}


public func s2toS2D(s2: S2) -> S2D {
  return S2D(
    offset: CGPoint(0, s2.offset),
    size: CGSize(w: 0, h: s2.size),
    master: CGRect(x: 0, y: s2.master.origin, width: 0, height: s2.master.size))
}

public func zipS2(xS2: S2, yS2: S2) -> S2D
{
  return S2D(
    offset: CGPoint(xS2.offset, yS2.offset),
    size: CGSize(w: xS2.size, h: yS2.size),
    master: CGRect(x: xS2.master.origin,
                   y: yS2.master.origin,
                   width: xS2.master.size,
                   height: yS2.master.size))
}

public func s2DtoS2YDim(s2: S2D) -> S2
{
  return S2(
    offset: s2.offset.y,
    size: s2.size.height,
    master: Rect(origin: s2.master.origin.y, size: s2.master.size.height))
}

public func s2DtoS2XDim(s2: S2D) -> S2
{
  return S2(
    offset: s2.offset.x,
    size: s2.size.width,
    master: Rect(origin: s2.master.origin.x, size: s2.master.size.width))
}


