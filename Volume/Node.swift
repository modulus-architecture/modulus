//
//  Node.swift
//  ScaffBuilder
//
//  Created by Justin Smith on 7/27/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import Foundation
import SceneKit

struct VectorMeasurement3 {
  var x: Measurement<UnitLength>
  var y: Measurement<UnitLength>
  var z: Measurement<UnitLength>
}

typealias Vector3 = SCNVector3

protocol Loadable {
    var fileName : String { get }
    var itemName : String { get }
}
extension Loadable {
    func load () -> Node {
        return MakeNode(fromLoader: self)
    }
}

public enum Axis { case x; case y; case z }

protocol Node {
    func clone() -> Self
    var location: VectorMeasurement3 { get set }
    var eulerAngles: Vector3 { get set }
    func addChildNode(_ child: Node)
    func flipAlong(_ axis: Axis)
    var scale: Vector3 { get set }
    func removeFromParentNode()
}


extension SCNNode : Node {
  
  // No
  var location: VectorMeasurement3 {
    get {
      return VectorMeasurement3(
        x: self.position.x.m,
        y: self.position.y.m,
        z: self.position.z.m
      )
    }
    set (newValue) {
      self.position =
        SCNVector3(
          x: newValue.x.converted(to: .meters).value,
          y: newValue.y.converted(to: .meters).value,
          z: newValue.z.converted(to: .meters).value)
    }
  }
  
    func addChildNode(_ child: Node) {
        self.addChildNode(child as! SCNNode)
    }
    func flipAlong(_ axis: Axis) {
        // In order to "cull" the flipped normals, of a negatively scaled item
        geometry?.firstMaterial?.isDoubleSided = true
      
        switch axis {
        case .x:
            scale = SCNVector3(x: -scale.x, y: scale.y, z: scale.z)
        case .y:
            scale = SCNVector3(x: scale.x, y: -scale.y, z: scale.z)
        case .z:
            scale = SCNVector3(x: scale.x, y: scale.y, z: -scale.z)
        }
        
    }

}



extension SCNGeometry {
    
}

func MakeNode(fromLoader loader: Loadable) -> Node {
    guard let scene = SCNScene(named: loader.fileName)
      else { fatalError ("NO File With the Name: (\(loader.fileName))") }
   guard let node = scene.rootNode.childNode(withName: loader.itemName, recursively: true)
     else { fatalError ("NO NODE With the Name: (\(loader.itemName))") }

    return node
}

func MakeNode(withGeometry geometry: SCNGeometry) -> Node {
    let tubeNode = SCNNode(geometry: geometry)
    return tubeNode
}


func MakeNode() -> Node { return SCNNode() }

// Primitive Geometry
func Box(width: Measurement<UnitLength>, height: Measurement<UnitLength>, length: Measurement<UnitLength>, chamferRadius: Measurement<UnitLength>) -> SCNGeometry
{
  return SCNBox(
    width: width.converted(to: .meters).value.cgFloat,
    height: height.converted(to: .meters).value.cgFloat,
    length: length.converted(to: .meters).value.cgFloat,
    chamferRadius: chamferRadius.converted(to: .meters).value.cgFloat)
}


func Tube(innerRadius: Measurement<UnitLength>, outerRadius: Measurement<UnitLength>, height: Measurement<UnitLength>) -> SCNGeometry
{
    let geom = SCNTube(innerRadius: innerRadius.converted(to: .meters).value.cgFloat, outerRadius: CGFloat(outerRadius.converted(to: .meters).value), height: CGFloat(height.converted(to: .meters).value))
    return geom
}

// Secondary Geometyr
//func CrossNode(armLength: Measurement<UnitLength>, centerPosition: VectorMeasurement3) -> Node
//{
//  let  = Tube(innerRadius: 0.mm, outerRadius: 3.cm, height: 15.cm)
//
//
//}

protocol Context {
    func add(node: Node)
    func add(nodes: [Node])
    func add(elements: [Element3D])
    func removeAll()
    func remove(elements: [Element3D])
}

extension CADView : Context {
    func removeAll() {
        self.removeContent()
    }
    func remove(elements: [Element3D]) {
        for n in elements {
            n.node.removeFromParentNode()
        }
    }
    func add(node: Node) {
        self.addContent(node: node as! SCNNode)
    }

    func add(nodes: [Node]) {
        for n in nodes {
            self.addContent(node: n as! SCNNode)
        }
    }
    func add(elements: [Element3D]) {
        for n in elements {
            self.addContent(node: n.processedNode as! SCNNode)
        }
    }
}



