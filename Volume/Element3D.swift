//
//  Element3D.swift
//  Deploy
//
//  Created by Justin Smith on 7/4/17.
//  Copyright © 2017 Justin Smith. All rights reserved.
//

import Foundation


protocol Element3D {
  
  var node : Node { get }
  var processedNode : Node { get }
  
  var position : (x: Measurement<UnitLength>, y: Measurement<UnitLength>, z: Measurement<UnitLength>) { get set }
}


extension Element3D
{
  // a bug here as my node stays the same but I append values to it
  var processedNode : Node {
    get
    {
      print(position)
      
      var pNode = node
      print(pNode.location)
      pNode.location.x += position.x
      pNode.location.y += position.z
      pNode.location.z -= position.y // Site world has z axis in the - direction
      print(pNode.location)
      return pNode
    }
  }
}


protocol HorizontalElement3D  : Element3D {
  var rotation : Degree { get set }
  
}


extension HorizontalElement3D
{
  var processedNode : Node {
    get
    {
      var pNode = node
      pNode.eulerAngles.y = rotation.toRadians
      pNode.location.x = pNode.location.x + position.x
      pNode.location.y = pNode.location.y + position.z
      pNode.location.z =  pNode.location.z - position.y // Site world has z axis in the - direction
      
      return pNode
    }
  }
}
