//
//  SCNBounder.swift
//  Deploy
//
//  Created by Justin Smith on 7/10/17.
//  Copyright © 2017 Justin Smith. All rights reserved.
//

import SceneKit

protocol SCNBounder {
  var boundingMinAndMax: (min: SCNVector3, max: SCNVector3)  { get }
  func boundingMinAndMax (of node: SCNNode ) -> (min: SCNVector3, max: SCNVector3)
}

extension SCNBounder where Self : SCNContentNodeProvider {
  var boundingMinAndMax: (min: SCNVector3, max: SCNVector3)
  {
    get {
      return self.boundingMinAndMax(of: contentNode)
    }
  }
  
  func boundingMinAndMax (of node: SCNNode ) -> (min: SCNVector3, max: SCNVector3)
  {
    var  min2 = SCNVector3()
    var max2 = SCNVector3()
    node.__getBoundingBoxMin(&min2, max: &max2)
    return (min2, max2)
  }
}
