//
//  ViewportAbstraction.swift
//  OffsetableCore
//
//  Created by Justin Smith on 5/25/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import Foundation
#if os(iOS)
import Geo
import Singalong
#else
import MacGeo
import SingalongMac
#endif


public struct ViewportAbstration
{
  var bounds: Extent
  var offset: Vector
  var size: Extent
  var scale: CGFloat
  var padding: Extent
  
  public init(bounds: Extent,
              offset: Vector,
              size: Extent,
              scale: CGFloat,
              padding: Extent) // Uniform
  {
    self.size = size
    self.padding = padding
    self.scale  = scale
    self.bounds = bounds
    self.offset = offset
  }
}


extension O1 {
  public init(viewportAbs: ViewportAbstration)
  {
    self.init(bounds: viewportAbs.bounds.magnitude,
              outerOrigin: viewportAbs.offset.magnitude * -1,
              outerSize: viewportAbs.size.magnitude +  viewportAbs.scale.magnitude * 2,
              origin: viewportAbs.padding.magnitude,
              size: viewportAbs.size.magnitude)
  }
}




