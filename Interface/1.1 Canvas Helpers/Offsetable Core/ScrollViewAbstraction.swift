//
//  ScrollViewAbstraction.swift
//  OffsetableCore
//
//  Created by Justin Smith on 5/26/18.
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
public struct ScrollViewAbstraction // Interface
{
  public var bounds: Extent
  public var exterior : ARect
  public var interior : ARect
}

extension ScrollViewAbstraction
{
  public init( o1: O1)
  {
    
    self.init(bounds:  o1.bounds |> Extent.init,
              exterior: ARect(origin: o1.outerOrigin |> APoint.init,
                              size: o1.outerSize |> Extent.init),
              interior: ARect(origin: o1.origin |> APoint.init,
                              size: o1.size |> Extent.init))
  }
}

public let makeClippedScrollview : (ViewportAbstration) -> ScrollViewAbstraction = posClipToO1 >>> ScrollViewAbstraction.init


