//
//  ViewportModel.swift
//  OffsetableCore
//
//  Created by Justin Smith on 5/25/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import CoreGraphics


// PaddedOffsetScaleableSize
// PosSize
public struct ViewportModel // Interface
{
  public var bounds: CGSize
  public var offset : CGVector
  
  public var size : CGSize
  public var scale : CGFloat
  public var padding : CGFloat // x2, Applied at top and at bottom
  
  
  public init(bounds: CGSize,
              offset: CGVector,
              size: CGSize,
              scale: CGFloat,
              padding: CGFloat) // Uniform
  {
    self.size = size
    self.padding = padding
    self.scale  = scale
    self.bounds = bounds
    self.offset = offset
  }
}


extension ViewportModel
{
  init (xUnits: ViewportAbstration, yUnits: ViewportAbstration)
  {
    precondition(xUnits.scale == yUnits.scale)
    precondition(xUnits.padding == yUnits.padding)
    self.init(bounds: CGSize(width: xUnits.bounds,height: yUnits.bounds),
              offset: CGVector(dx: xUnits.offset,dy: yUnits.offset),
              size: CGSize(width: xUnits.size, height:yUnits.size),
              scale: xUnits.scale,
              padding: xUnits.padding.magnitude)
  }
}
