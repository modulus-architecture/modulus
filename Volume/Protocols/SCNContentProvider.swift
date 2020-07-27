//
//  SCNContentProvider.swift
//  Deploy
//
//  Created by Justin Smith on 7/9/17.
//  Copyright © 2017 Justin Smith. All rights reserved.
//

import SceneKit

protocol SCNContentNodeProvider {
  var contentNode : SCNNode { get }
}

protocol SCNContentContext : SCNProvider, SCNContentNodeProvider, SCNBounder{
  func addContent(node: SCNNode)
  func removeContent()
}

extension SCNContentContext
{
  func addContent(node: SCNNode) {
    
    contentNode.addChildNode(node)
    
    let (min, max) = boundingMinAndMax(of: contentNode)
    
    let xDelta = max.x - min.x
    let yDelta = max.y - min.y
    let zDelta = max.z - min.z
    
    contentNode.position.x = -xDelta/2
    contentNode.position.y = -yDelta/2
    contentNode.position.z = zDelta/2
  }
  
  func removeContent()
  {
    for node in contentNode.childNodes
    {
      node.removeFromParentNode()
    }
  }
}
