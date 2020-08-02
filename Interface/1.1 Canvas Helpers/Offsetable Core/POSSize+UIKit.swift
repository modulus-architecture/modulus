import Foundation


private var _scale : CGFloat = 10.0


extension PosSize {
  public init ( _ p1: PosSize1D )
  {
    self.init(size: size3(p1.size),
              padding: p1.padding,
              scale: p1.scale,
              boundary: size1(p1.boundary),
              contentOrigin: point2(p1.contentOrigin),
              contentSize: size2(p1.contentSize))
  }
}



extension PosSize1D {
  public init ( _ p2: PosSize )
  {
    self.init(size: p2.size.height / _scale,
              padding: p2.padding / _scale,
              scale: p2.scale / _scale,
              boundary: p2.boundary.height / _scale,
              contentOrigin: p2.contentOrigin.y / _scale,
              contentSize: p2.contentSize.height / _scale)
  }
}

let scaledPoint : (CGFloat,CGFloat)->CGPoint = { x,y in CGPoint(x:x * _scale, y:y * _scale)}
let scaledSize : (CGFloat,CGFloat)->CGSize = { w,h in CGSize(width: w * _scale, height: h * _scale)}

public let size1 = 40 |> curry(scaledSize)
public let size2 = 30 |> curry(scaledSize)
public let size3 = 20 |> curry(scaledSize)
public let point1 = 0 |> curry(scaledPoint)
public let point2 = 5 |> curry(scaledPoint)
public let point3 = 5 |> curry(scaledPoint)
public let frame = { o, s in CGRect.init(origin: o, size: s) }



#if os(iOS)
import Geo
import UIKit
import Singalong


public func pos2View( setup: PosSize) -> (UIView, UIView, UIView)
{
  let interiorView = UIView()
  interiorView.frame = frame(point3(setup.padding), setup.size)
  
  let exteriorView = UIView(frame: frame(setup.contentOrigin, setup.contentSize))
  exteriorView.addSubview(interiorView)
  
  let portFrame = CGRect(origin: CGPoint.zero, size: setup.boundary)
  let port = UIView( frame: portFrame)
  port.addSubview(exteriorView)
  
  return (port, exteriorView, interiorView)
}


public func pos2ViewApply(
  assembly: (port: UIView, exteriorView:UIView, interiorView:UIView),
  setup: PosSize)
{
  assembly.interiorView.frame = frame(point3(setup.padding), setup.size)
  assembly.exteriorView.frame =  frame(setup.contentOrigin, setup.contentSize)
  assembly.port.frame = CGRect(origin: assembly.port.frame.origin, size: setup.boundary)
  
  assembly.exteriorView.addSubview(assembly.interiorView)
  assembly.port.addSubview(assembly.exteriorView)
}

#else
import MacGeo
import SingalongMac
#endif



