//
//  ScrollViewModel.swift
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






// PaddedOffsetScaleableSize
// PosSize
public struct ScrollViewModel // Interface
{
  public var bounds: CGSize
  public var exterior : CGRect
  public var interior : CGRect
  
//  public init(bounds: CGSize,
//              exterior: CGRect,
//              interior: CGRect) // Uniform
//  {
//    self.bounds = bounds
//    self.exterior = exterior
//    self.interior  = interior
//  }
}

extension ScrollViewModel
{
  public init (viewportModel: ViewportModel )
  {
    let origin = CGPoint(x:viewportModel.padding,
                         y:viewportModel.padding)
    
    let interiorFrame = CGRect(origin: origin ,
                               size: viewportModel.size)
    
    let exteriorFrame = CGRect(origin: (viewportModel.offset * -1.0).asPoint(),
                               size: viewportModel.size + origin.asVector()*2 )
    
    self.init(bounds: viewportModel.bounds,
              exterior: exteriorFrame,
              interior: interiorFrame
    )
  }
  
  public init (xUnit: ScrollViewAbstraction, yUnit: ScrollViewAbstraction )
  {
    
    self.init(bounds: CGSize(width: xUnit.bounds,
                             height: yUnit.bounds),
              exterior: CGRect(x: xUnit.exterior.origin,
                               y: yUnit.exterior.origin,
                               width: xUnit.exterior.size,
                               height: yUnit.exterior.size),
      interior: CGRect(x: xUnit.interior.origin,
                       y: yUnit.interior.origin,
                       width: xUnit.interior.size,
                       height: yUnit.interior.size)
    )
  }
  
}



